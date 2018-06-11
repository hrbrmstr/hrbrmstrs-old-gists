library(inline)

.char_unique_code <- "
std::vector < std::string > s = as< std::vector < std::string > >(x);
unsigned int input_size = s.size();
std::vector < std::string > chrs(input_size);
for (unsigned int i=0; i<input_size; i++) {
  std::string t = s[i];
  for (std::string::iterator chr=t.begin();
       chr != t.end(); ++chr) {
    if (chrs[i].find(*chr) == std::string::npos) { chrs[i] += *chr; }
  }
}
return(wrap(chrs));
"

char_unique <- 
  rcpp(sig=signature(x="std::vector < std::string >"),
       body=.char_unique_code,
       includes=c("#include <string>",
                  "#include <iostream>"))

char_unique("banana")
nchar(char_unique("banana"))
