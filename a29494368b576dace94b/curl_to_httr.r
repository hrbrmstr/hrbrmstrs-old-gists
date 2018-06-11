library(httr)
library(clipr)
library(stringr)
library(Hmisc)

cput <- function(cmd=read_clip(), include_useragent=FALSE, include_referer=FALSE) {

  # strip off the leading `curl` if it exists
  cmd <- str_replace(cmd, "^curl\ +", "")

  # here is our URL
  URL <- str_match(cmd, "^'([[:alnum:]/:_\\. \\+\\[\\]\"\\{\\}\\?;&%\\(\\),\\-=]+)'")[,2]
  URL_parsed <- parse_url(URL)

  base_url <- modify_url("", URL_parsed$scheme, URL_parsed$hostname, URL_parsed$port, URL_parsed$path)

  query <- ""
  if (!is.null(URL_parsed$query)) {
    query <- ",\n  query = list("
    paste(sapply(names(URL_parsed$query), function(xn) {
      sprintf("\n    `%s` = '%s'", xn, URL_parsed$query[[xn]])
    }), collapse=", ") -> query_bits
    query <- sprintf("%s%s\n  )", query, query_bits)
  }

  headers <- str_match_all(cmd, "-H '([[:alnum:]/:_\\. \\+\\[\\]\"\\{\\}\\?;&\\(\\),\\-=]+)' ")[[1]][,2]

  # we can exclude these headers from httr::GET or httr::POST
  if (length(headers) > 0) {
    headers <- grep("^(Accept-Encoding|DNT|Connection|Upgrade-Insecure-Requests|Accept-Language|Cache-Control|Origin)",
                  headers, invert=TRUE, value=TRUE, ignore.case=TRUE)
  }

  # if encoding is specified, then handle it here and remove the explicit
  # header and let httr handle setting it properly
  encode <- ""
  encode_flag <- NULL
  if (length(headers) > 0 & sum(grepl("^Content-Type", headers, ignore.case=TRUE))>0) {
    ctype <- grep("^Content-Type", headers, value=TRUE, ignore.case=TRUE)
    if (grepl("urlencoded", ctype)) {
      encode = ",\n  encode = 'form'"
      encode_flag <- "form"
    } else if (grepl("multipart", ctype)) {
      encode = ",\n  encode = 'multipart'"
      encode_flag <- "multipart"
    } else {
      encode = ",\n  encode = 'json'"
      encode_flag <- "json"
    }

    # remove the content-type from the header pool
    #headers <- grep("^Content-Type", headers, invert=TRUE, value=TRUE, ignore.case=TRUE)
  }

  # process user options
  if (length(headers) > 0 & !include_useragent)
    headers <- grep("^User-Agent", headers, invert=TRUE, value=TRUE, ignore.case=TRUE)

  if (length(headers) > 0 & !include_referer)
    headers <- grep("^Referer", headers, invert=TRUE, value=TRUE, ignore.case=TRUE)

  # build add_headers() parameter
  heads <- ""
  if (length(headers) > 0) {
    header_names <- str_match(headers, "^([[:alnum:]-]+):")[,2]
    header_vals <- str_replace_all(headers, paste("^", header_names, ": ", sep=""), "")
    heads <- sprintf(",\n  add_headers(%s)\n", paste0(mapply(function(n, v) {
      paste(paste("`", n, "` = '", v, "'", sep=""), sep=",")
    }, header_names, header_vals, USE.NAMES=FALSE), collapse=",\n              "))
    names(header_vals) <- header_names
  }

  # presence of --data or --data-binary means POST request
  body <- ""
  data_post <- str_extract(cmd, "(--data-binary|--data) '.*'")
  if (!is.na(data_post)) {
    db <- grepl("--data-binary", data_post)
    if (!db) {
      data_post <- str_replace_all(data_post, "(^--data '|'$)", "")
      data_post_decoded <- parse_url(sprintf("http://example.com/?%s", data_post))
      body <- ",\n body = list("
      paste(sapply(names(data_post_decoded$query), function(xn) {
        sprintf("\n    `%s` = '%s'", xn, data_post_decoded$query[[xn]])
      }), collapse=", ") -> body_bits
      body <- sprintf("%s%s\n  )", body, body_bits)
    } else {
      data_post <- str_replace_all(data_post, "(^--data-binary '|'$)", "")
      body <- sprintf(",\n  body = '%s'", data_post)
    }
  } else {
    data_post <- NULL
  }

  if (is.null(data_post)) {
    req <- sprintf("response <- GET('%s'%s%s)", base_url, query, heads)
    cat(req)
    write_clip(req)
    return(invisible(req))
  } else {
    req <- sprintf("response <- POST('%s'%s%s%s%s)", base_url, encode, query, body, heads)
    cat(req)
    write_clip(req)
    return(invisible(req))
  }

}


c1 <- "curl 'http://ceogoa.nic.in/appln/UIL/ElectoralRoll.aspx' -H 'Cookie: ASP.NET_SessionId=cyn1r33tw5jwrxes2jkvs03p' -H 'Origin: http://ceogoa.nic.in' -H 'Accept-Encoding: gzip, deflate' -H 'Accept-Language: en-US,en;q=0.8' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/45.0.2454.85 Safari/537.36' -H 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8' -H 'Accept: */*' -H 'Cache-Control: no-cache' -H 'X-Requested-With: XMLHttpRequest' -H 'Connection: keep-alive' -H 'X-MicrosoftAjax: Delta=true' -H 'DNT: 1' -H 'Referer: http://ceogoa.nic.in/appln/UIL/ElectoralRoll.aspx' --data 'ctl00%24ToolkitScriptManager=ctl00%24ToolkitScriptManager%7Cctl00%24Main%24btnSearch&_TSM_HiddenField_=gw7jpIJ8LMgM7u8gLjQBxxbgFlVTP1p_vIL8EuJVw1w1&__EVENTTARGET=&__EVENTARGUMENT=&__VIEWSTATE=%2FwEPDwULLTEzNjg2NjEyMTEPZBYCZg9kFgICAw9kFgQCcw9kFgYCBQ9kFgJmD2QWAmYPZBYCAgEPZBYCZg9kFgICAQ8WAh4FY2xhc3NlFgICAQ8PFgIeB1Zpc2libGVoZBYCAgEPZBYCZg9kFgJmD2QWAgIBDw8WAh4EVGV4dGVkZAIJDxBkDxYpZgIBAgICAwIEAgUCBgIHAggCCQIKAgsCDAINAg4CDwIQAhECEgITAhQCFQIWAhcCGAIZAhoCGwIcAh0CHgIfAiACIQIiAiMCJAIlAiYCJwIoFikQBQlTZWxlY3QuLi4FATBnEAUJMS1NYW5kcmVtBQUwNTAwMWcQBQgyLVBlcm5lbQUFMDUwMDJnEAUKMy1CaWNob2xpbQUFMDUwMDNnEAUHNC1UaXZpbQUFMDUwMDRnEAUINS1NYXB1c2EFBTA1MDA1ZxAFCDYtU2lvbGltBQUwNTAwNmcQBQk3LVNhbGlnYW8FBTA1MDA3ZxAFCzgtQ2FsYW5ndXRlBQUwNTAwOGcQBQo5LVBvcnZvcmltBQUwNTAwOWcQBQkxMC1BbGRvbmEFBTA1MDEwZxAFCTExLVBhbmFqaQUFMDUwMTFnEAULMTItVGFsZWlnYW8FBTA1MDEyZxAFCjEzLVN0LkNydXoFBTA1MDEzZxAFDDE0LVN0LiBBbmRyZQUFMDUwMTRnEAUMMTUtQ3VtYmFyanVhBQUwNTAxNWcQBQcxNi1NYWVtBQUwNTAxNmcQBQwxNy1TYW5xdWVsaW0FBTA1MDE3ZxAFCTE4LVBvcmllbQUFMDUwMThnEAUJMTktVmFscG9pBQUwNTAxOWcQBQgyMC1QcmlvbAUFMDUwMjBnEAUIMjEtUG9uZGEFBTA1MDIxZxAFCTIyLVNpcm9kYQUFMDUwMjJnEAUKMjMtTWFyY2FpbQUFMDUwMjNnEAULMjQtTW9ybXVnYW8FBTA1MDI0ZxAFEDI1LVZhc2NvLURhLUdhbWEFBTA1MDI1ZxAFCjI2LURhYm9saW0FBTA1MDI2ZxAFCzI3LUNvcnRhbGltBQUwNTAyN2cQBQgyOC1OdXZlbQUFMDUwMjhnEAULMjktQ3VydG9yaW0FBTA1MDI5ZxAFCjMwLUZhdG9yZGEFBTA1MDMwZxAFCTMxLU1hcmdhbwUFMDUwMzFnEAULMzItQmVuYXVsaW0FBTA1MDMyZxAFCjMzLU5hdmVsaW0FBTA1MDMzZxAFCzM0LUN1bmNvbGltBQUwNTAzNGcQBQgzNS1WZWxpbQUFMDUwMzVnEAUJMzYtUXVlcGVtBQUwNTAzNmcQBQwzNy1DdXJjaG9yZW0FBTA1MDM3ZxAFDDM4LVNhbnZvcmRlbQUFMDUwMzhnEAUKMzktU2FuZ3VlbQUFMDUwMzlnEAULNDAtQ2FuYWNvbmEFBTA1MDQwZ2RkAhEPZBYCZg9kFgICAQ88KwANAGQCdQ9kFgQCAQ9kFgICAQ9kFgICAQ8PFgIfAgUHwqkgMjAxNWRkAgIPZBYCAgEPZBYCAgMPDxYCHwIFBjg2OTAwNGRkGAEFD2N0bDAwJE1haW4kZ3ZBQw9nZM67BlVpWuq3JLy1D9t%2FgAYOnmVk&ctl00%24Main%24drpAC=05001&ctl00%24Main%24vcAC_ClientState=&__ASYNCPOST=true&ctl00%24Main%24btnSearch=Search' --compressed"
cput(c1)

c2 <- "curl 'https://httpbin.org/get?show_env=1' -H 'dnt: 1' -H 'accept-encoding: gzip, deflate, sdch' -H 'accept-language: en-US,en;q=0.8' -H 'upgrade-insecure-requests: 1' -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/45.0.2454.85 Safari/537.36' -H 'accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' --compressed"
cput(c2)

# curl 'https://data.cityofchicago.org/views/INLINE/rows.json?accessType=WEBSITE&method=getByIds&asHashes=true&start=0&length=50&meta=true' -H 'Cookie: _socrata_session_id=BAh7B0kiD3Nlc3Npb25faWQGOgZFRiIlYzhiMWM3NmQ4ZTgwOTA0YjgzODA0NjkzOTAwZGUwYjZJIhBfY3NyZl90b2tlbgY7AEZJIjFPaVpoWVpuRmlseEVodHljcUhGREszWFREcUtVTTF2TGRtTTJramU3YXJVPQY7AEY%3D--74881294d11d1e35efa9fc45da5393b8f9cdf10e; socrata-csrf-token=OiZhYZnFilxEhtycqHFDK3XTDqKUM1vLdmM2kje7arU%3D' -H 'Origin: https://data.cityofchicago.org' -H 'Accept-Encoding: gzip, deflate' -H 'X-CSRF-Token: OiZhYZnFilxEhtycqHFDK3XTDqKUM1vLdmM2kje7arU=' -H 'Accept-Language: en-US,en;q=0.8' -H 'X-Socrata-Federation: Honey Badger' -H 'X-Requested-With: XMLHttpRequest' -H 'Connection: keep-alive' -H 'X-App-Token: U29jcmF0YS0td2VraWNrYXNz0' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/45.0.2454.85 Safari/537.36' -H 'Content-Type: application/json' -H 'Accept: application/json, text/javascript, */*; q=0.01' -H 'Cache-Control: max-age=0' -H 'Referer: https://data.cityofchicago.org/Administration-Finance/Current-Employee-Names-Salaries-and-Position-Title/xzkq-xp2w' -H 'DNT: 1' --data-binary '{"id":"xzkq-xp2w","name":"Current Employee Names, Salaries, and Position Titles","attribution":"City of Chicago","attributionLink":"http://www.cityofchicago.org","category":"Administration & Finance","description":"This dataset is a listing of all current City of Chicago employees, complete with full names, departments, positions, and annual salaries. For hourly employees the annual salary is estimated. Data Owner: Human Resources. Frequency: Data is updated quarterly. For information on the positions and related salaries detailed in the annual budgets, see https://data.cityofchicago.org/browse?limitTo=datasets&q=\"Budget+Ordinance+-+Positions+and+Salaries\"&sortBy=newest&tags=budget.","displayType":"table","publicationAppendEnabled":false,"columns":[{"id":206559137,"name":"Name","fieldName":"name","position":1,"width":148,"dataTypeName":"text","tableColumnId":1532233,"format":{"aggregate":"count","align":"left"},"flags":null,"metadata":{}},{"id":206559138,"name":"Position Title","fieldName":"job_titles","position":2,"width":220,"dataTypeName":"text","tableColumnId":1532235,"format":{"align":"left"},"flags":null,"metadata":{}},{"id":206559139,"name":"Department","fieldName":"department","position":3,"width":183,"dataTypeName":"text","tableColumnId":1532236,"format":{},"flags":null,"metadata":{}},{"id":206559140,"name":"Employee Annual Salary","fieldName":"employee_annual_salary","position":4,"width":161,"dataTypeName":"money","tableColumnId":1532237,"format":{"aggregate":"sum","humane":"false","currency":"USD","align":"right"},"flags":null,"metadata":{}}],"metadata":{"custom_fields":{"Metadata":{"Data Owner":"Human Resources","Time Period":"Last Updated June 2015","Frequency":"Data are updated quarterly"}},"renderTypeConfig":{"visible":{"table":true}},"rowLabel":"Row","availableDisplayTypes":["table","fatrow","page"],"rdfSubject":"0","filterCondition":{"value":"AND","children":[{"value":"OR","type":"operator","metadata":{"includeAuto":15,"tableColumnId":{"241512":1532236},"operator":"EQUALS"}}],"type":"operator","metadata":{"unifiedVersion":2,"advanced":true}},"rowIdentifier":"0","rdfClass":"","jsonQuery":{"order":[{"columnFieldName":"name","ascending":true}]}},"query":{"orderBys":[{"ascending":true,"expression":{"columnId":206559137,"type":"column"}}]},"tags":["personnel"],"flags":["default"],"originalViewId":"xzkq-xp2w","displayFormat":{}}' --compressed
cput()

