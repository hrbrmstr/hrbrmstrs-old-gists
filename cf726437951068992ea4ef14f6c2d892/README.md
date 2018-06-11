The site doesn't load the data dynamically but has it in one GIANT javascript `<script>` block, so we have to:

- find that block
- extract the block contents
- split it into lines (thankfully the data is all on one GIANT line)
- pick the right line
- clean it up a bit so it's just exposing the JSON data (if it were javascript code we could still do it)
- shunt it to `jsonlite`
