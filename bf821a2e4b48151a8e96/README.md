Main differences are:

- All the initial data acquisition & munging is kept in one pipeline and the data structure is kept as a `tbl_df`
- I ended up having to use `html_session` since the site was rejecting the access (login req'd) w/o it
- The `for` loop is now an `apply` iteration and `pbapply` gives you a progress bar for free which is A Good Thing given how long that operation took :-)
- The move to `pbapply` makes it possible to do the row-binding and left-joining in a single pipeline, which keeps everything in a `tbl_df`. 
- Your `for` solution can be made almost as efficient if you do a `img_list <- vector("list", 150)` so the list size is pre-allocated.

BTW: the `popup` code is *brilliant* and `tigris` is equally as brilliant!