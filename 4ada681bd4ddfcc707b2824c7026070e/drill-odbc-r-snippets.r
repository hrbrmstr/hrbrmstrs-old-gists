snippet drillodbcdistributed
	library(DBI)
	library(odbc)
	library(tidyverse)

	DBI::dbConnect(
	  odbc::odbc(), 
	  driver = "/Library/mapr/drill/lib/libdrillodbc_sbu.dylib",
	  ConnectionType = "Zookeeper",
	  AuthenticationType = "No Authentication",
	  ZKCLusterID = "CLUSTERID",
	  ZkQuorum = "HOST:2181",
	  AdvancedProperties = "CastAnyToVarchar=true;HandshakeTimeout=30;QueryTimeout=180;TimestampTZDisplayTimezone=utc;
	  ExcludedSchemas=sys,INFORMATION_SCHEMA;NumberOfPrefetchBuffers=5;"
	) -> drill_con

snippet drillodbcstandalone
	library(DBI)
	library(odbc)
	library(tidyverse)

	DBI::dbConnect(
	  odbc::odbc(),
	  driver = "/Library/mapr/drill/lib/libdrillodbc_sbu.dylib",
	  Host = "localhost",
	  Port = "31010",
	  ConnectionType = "Direct to Drillbit",
	  AuthenticationType = "No Authentication",
	  ZkClusterID = "drillbits1",
	  ZkQuorum = ""
	)
