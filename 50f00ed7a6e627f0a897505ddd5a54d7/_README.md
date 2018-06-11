The idea is to have the records be semi-"normalized" so they can be easily used directly by code/utils/system that process ndjson or easily converted to parquet/avro/etc as those formats support nested data formats in columns.

This particular "schema" has word well in both my `ndjson` R package, Apache Drill, `jq` and some ndjson CLI utils.

Since this format is meant for programs and not humans, all whitespace has been removed.