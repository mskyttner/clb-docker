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




Unless you have done so it would be good if you had a look at the data model and the minimal documentation that we currently have:
https://github.com/gbif/checklistbank/tree/master/docs

http://gbif.blogspot.de/2016/04/updating-gbif-backbone.html
http://gbif.blogspot.de/2016/08/gbif-backbone-august-2016-update.html
http://gbif.blogspot.de/2015/03/improving-gbif-backbone-matching.html

I hope I find some time beforehand to better document the indexing & backbone building setup & features.
 But time is moving fast so I am not sure how far I can get by then.



In case you wanna dive into the gory coding details here are the open issues for ChecklistBank & Backbone building:
http://dev.gbif.org/issues/issues/?filter=13400
http://dev.gbif.org/issues/issues/?filter=12200

Quite a few of them are true content issues we haven’t tagged accordingly, so you can skip over many of them.

And this for the next backbone building sprint:
http://dev.gbif.org/issues/browse/POR-3156

