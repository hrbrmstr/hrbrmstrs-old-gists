# Getting Apache Drill in single-node cluster mode on macOS

## zookeeper

```shell
brew install zookeeper`
ln -sfv /usr/local/opt/zookeeper/homebrew.mxcl.zookeeper.plist ~/Library/LaunchAgents
```

## drill 

`wget https://www-us.apache.org/dist/drill/drill-1.10.0/apache-drill-1.10.0.tar.gz`

- NOTE you should validate the dl w/pgp
- extract to `/usr/local`
- `ln -s` it to `/usr/local/drill`

## setup local drillbit mode vs use drill-embedded

edit `/usr/local/drill/conf/drill-override.conf`:

```conf
drill.exec: {
  cluster-id: "COOL_CLUSTER_ID_NAME",                                      # keep it short
  zk.connect: "localhost:2181",                                            # use zookeeper
  store.json.reader.skip_invalid_records: true,                            # handle bad json more gracefully
  sys.store.provider.local.path: "/usr/local/drill/conf/storage.conf"      # persist storage provider config changes
}
```

## startup

```startup
$ drillbit.sh start
```