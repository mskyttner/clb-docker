# nub-docker

Dockerized build for GBIF taxonomy tools - checklistbank

Beware - this is work in progress!

# TODO

- deploy build artefacts (.jar)
- load data from DarwinCare Archives using the cli?
- automate subset extraction from http://dl.dropbox.com/u/523458/Dyntaxa/Archive.zip (dataset from 2012-March-08)

# Further Reading

Documentation here:

https://github.com/gbif/checklistbank/tree/master/docs
http://gbif.blogspot.de/2016/04/updating-gbif-backbone.html
http://gbif.blogspot.de/2016/08/gbif-backbone-august-2016-update.html
http://gbif.blogspot.de/2015/03/improving-gbif-backbone-matching.html

# Known issues

One test fails - seems to require some "rabbitmq" config that currently fails:

testStartUp(org.gbif.checklistbank.cli.importer.ImporterServiceIT)  Time elapsed: 4.545 sec  <<< ERROR!
java.io.IOException: null
	at com.rabbitmq.utility.ValueOrException.getValue(ValueOrException.java:67)
	at com.rabbitmq.utility.BlockingValueOrException.uninterruptibleGetValue(BlockingValueOrException.java:33)
	at com.rabbitmq.client.impl.AMQChannel$BlockingRpcContinuation.getReply(AMQChannel.java:343)
	at com.rabbitmq.client.impl.AMQChannel.privateRpc(AMQChannel.java:216)
	at com.rabbitmq.client.impl.AMQChannel.exnWrappingRpc(AMQChannel.java:118)
	at com.rabbitmq.client.impl.AMQConnection.start(AMQConnection.java:388)
	at com.rabbitmq.client.ConnectionFactory.newConnection(ConnectionFactory.java:516)
	at com.rabbitmq.client.ConnectionFactory.newConnection(ConnectionFactory.java:533)
	at org.gbif.common.messaging.DefaultMessagePublisher.<init>(DefaultMessagePublisher.java:74)
	at org.gbif.common.messaging.DefaultMessagePublisher.<init>(DefaultMessagePublisher.java:52)
	at org.gbif.checklistbank.cli.common.RabbitBaseService.startUp(RabbitBaseService.java:94)
	at org.gbif.checklistbank.cli.importer.ImporterService.startUp(ImporterService.java:84)
	at org.gbif.checklistbank.cli.importer.ImporterServiceIT.testStartUp(ImporterServiceIT.java:27)
Caused by: java.net.SocketException: Connection reset
	at java.net.SocketInputStream.read(SocketInputStream.java:209)
	at java.net.SocketInputStream.read(SocketInputStream.java:141)
	at java.io.BufferedInputStream.fill(BufferedInputStream.java:246)
	at java.io.BufferedInputStream.read(BufferedInputStream.java:265)
	at java.io.DataInputStream.readUnsignedByte(DataInputStream.java:288)
	at com.rabbitmq.client.impl.Frame.readFrom(Frame.java:95)
	at com.rabbitmq.client.impl.SocketFrameHandler.readFrame(SocketFrameHandler.java:131)
	at com.rabbitmq.client.impl.AMQConnection$MainLoop.run(AMQConnection.java:515)

