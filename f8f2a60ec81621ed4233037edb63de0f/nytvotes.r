refresh_vote <- function(nyt_json_url) {
  
  mtp <- jsonlite::fromJSON(nyt_json_url) 
  
  with(
    mtp$summary, 
    sprintf(
      "%s\n\nYes: %d; No: %d; Present: %d; Not Voting: %d\n\nUpdated: %s EDT",
      alert, yes_votes, no_votes, present_votes, not_voting, 
      anytime::anytime(updated, tz="US/Pacific") - 3600)
    ) %>% 
    cat()
  
}

refresh_vote('https://intf.nyt.com/newsgraphics/2017/live-congressional-votes/healthcare-mtp.json')