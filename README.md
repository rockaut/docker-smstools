# docker-smstools

A simple Docker image for running smstools (http://smstools3.kekekasvi.com/) based on alpine.

## Spooler directory volume/binds

The container needs a volume mapped for spooling the messages. It can be a docker bind `-v "$PWD/spool-sms:/var/spool/sms"`
or a docker volume `-v "spool-sms:/var/spool/sms"`.
On start the container checks for the needed subfolders an creates them if needed. You may have to check the output if there are permission related problems.

## device and smsd.conf

To map the wanted device just do the standard `--device /dev/ttyS0:/dev/ttyS0`. As a default following smsd.conf is used:
```sh
devices = GSM1
logfile = 1                       ## logs directly to stdout
loglevel = 7

outgoing = /var/spool/sms/outgoing
checked = /var/spool/sms/checked
failed = /var/spool/sms/failed
incoming = /var/spool/sms/incoming
sent = /var/spool/sms/sent

[GSM1]
device = /dev/ttyS0               ## this must match your passed device!
incoming = no                     ## no listening/receiving per default!
signal_quality_ber_ignore = yes   ## dont probe quality per default!
```

If you want other configs or using another device than /dev/ttyS0 you have to pass the modified smsd.conf like `-v "$PWD/my.conf:/etc/smsd.conf`.

## Usage

Starting the container on ttyS0 with all defaults:

```sh
docker run --name smstools -ti \
           --device /dev/ttyS0:/dev/ttyS0 \
           -v "$PWD/sms:/var/spool/sms \
           -d rockaut/smstools
```

Running the container detached with ttyS1 and modified smsd.conf:

```sh
docker run --name smstools -ti \
           --device /dev/ttyS1:/dev/ttyS1 \
           -v "$PWD/my.conf:/etc/smsd.conf \
           -v "$PWD/sms:/var/spool/sms \
           -d rockaut/smstools
```

To check if sending works just create an sendfile in $PWD/sms/outgoing (on your host not in the container):

```sh
echo -e "To: +12345678\nAlphabet: UTF-8\n\nIt just works :)" > $PWD/sms/outgoing/$(date +%s)
```

You may also exec into the container with `docker exec -ti smstools sh` (no bash on Alpine ;-)) or even start it attached/without starting the sms daemon:

```sh
docker run --name smstools -ti \
           --device /dev/ttyS1:/dev/ttyS1 \
           -v "$PWD/my.conf:/etc/smsd.conf \
           -v "$PWD/sms:/var/spool/sms \
           rockaut/smstools sh
```