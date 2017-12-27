# Rubifying

## hello-world

Example of class definition and array management.

```
ruby hello-world.rb
```

## encrypt

Manages a large encrypted CSV file.
.1 Generates a random password that will be eventually encrypted (`password.enc.txt`)
.2 Appends rows to a id-value CSV file encrypted in memory using the random password (`output.enc.csv`)
.3 Encrypt the password using a public key (`public_key.pem`)

```
ruby CsvEncrypter.rb
```

How to decrypt the result:

```
openssl smime -decrypt -binary -in password.enc.txt -out password.txt -aes256 -inkey private_key.pem
openssl enc -d -aes-256-cbc -a -in output.enc.csv -out output.csv -pass file:password.txt
```