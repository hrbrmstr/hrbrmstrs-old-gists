library(xml2)
library(httr)
library(R.utils)
library(magrittr)
library(dplyr)

# this will download to disk and not re-download if the file already exists
warn_for_status(GET("http://static.nvd.nist.gov/feeds/xml/cve/nvdcve-2.0-2015.xml.gz", 
                    write_disk("nvdcve-2.0-2015.xml.gz")))

# this will unzip the downloaded file and keep the gz version (so the above will not
# re-download)
gunzip("nvdcve-2.0-2015.xml.gz", remove=FALSE)

# read in the XML file
nvd <- read_xml("nvdcve-2.0-2015.xml")

# name the default namespace and shorten the others since the government (and MITRE) is namespace-happy
ns <- xml_ns_rename(xml_ns(nvd), d1="n", `scap-core`="sc", cvss="cv", vuln="v", xsi="x", patch="p", `cpe-lang`="cl")

# get all the CVE entry ids
nvd %>% 
  xml_find_all(xpath="/n:nvd/n:entry/v:cve-id", ns) %>% 
  xml_text() -> cves

# get the summary
nvd %>% 
  xml_find_all(xpath="/n:nvd/n:entry/v:summary", ns) %>% 
  xml_text() -> vuln_summary

dat <- data_frame(cve=cves, v_sum=vuln_summary)
