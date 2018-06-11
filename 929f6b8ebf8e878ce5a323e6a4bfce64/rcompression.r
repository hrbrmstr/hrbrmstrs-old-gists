library(inline)

gz_compress <- cfunction(
  sig=c(r_content="raw"),
  body="
  int status, numProtects = 0, level = 1, method = Z_DEFLATED, 
      windowBits = 15+16, memLevel = 9, strategy = 0;
  uLongf destLen = 0;
  z_stream strm;  
  
  strm.zalloc = NULL;
  strm.zfree = NULL;
  strm.opaque = NULL;
  strm.total_out = 0;
  strm.next_in = RAW(r_content);
  strm.avail_in = GET_LENGTH(r_content);

  SEXP r_result = Rf_allocVector(RAWSXP, strm.avail_in * 1.01 + 12);
  
  status = deflateInit2(&strm, level, method, windowBits, memLevel, strategy);
  if(status != Z_OK) return(r_content);
  
  destLen = GET_LENGTH(r_result);
  
  do {
    strm.next_out = RAW(r_result) + strm.total_out;
    strm.avail_out = destLen - strm.total_out;
  
    status = deflate(&strm, Z_FINISH);
    if (status == Z_STREAM_END) 
      break;
    else if (status == Z_OK) {
      SET_LENGTH(r_result, 2*destLen);
      PROTECT(r_result); numProtects++;
      destLen *= 2;
    } else if (status == Z_MEM_ERROR) {
      return(r_content);
    }
  } while(1);
  
  SET_LENGTH(r_result, strm.total_out);
  
  deflateEnd(&strm);
  
  if (numProtects) UNPROTECT(numProtects);
  
  return(r_result);
  ",
  includes=c("#include <zlib.h>", "#include <Rdefines.h>", "#include <Rinternals.h>", '#include "R_ext/Memory.h"', '#include "R_ext/Utils.h"'),
  libargs="-lz"
)
