void R_message(const char *txt) {
  SEXP r_msg = install("message");
  SEXP call_msg = PROTECT(lang2(r_msg, ScalarString(mkChar(txt))));
  eval(call_msg, R_BaseEnv);
  UNPROTECT(1);
}