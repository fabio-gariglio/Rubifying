require "open3"
require "securerandom"

class CsvEncrypter

    def initialize (publicKeyFilename:, encryptedOutputFilename:, encryptedPasswordFilename:)
        if File.file?(publicKeyFilename)
            @publicKeyFilename = publicKeyFilename
        else
            throw "Public key #{publicKeyFilename} does not exist!"
        end

        @passwordFilename = "#{SecureRandom.uuid}-password.txt"
        @encryptedOutputFilename = encryptedOutputFilename
        @encryptedPasswordFilename = encryptedPasswordFilename

        puts "Generating temporary password..."
        system "openssl rand -base64 2048 > #{@passwordFilename}"        
        puts "Temporary password generated."
    end

    def open_stream
        puts "Generating encryption stream '#{@encryptedOutputFilename}'..."
        command = "openssl enc -aes-256-cbc -a -salt -out #{@encryptedOutputFilename} -pass file:#{@passwordFilename}"
        @stdin, @stdout, @stderr, wait_thr = Open3.popen3(command)        
        @stdin.print "Id,Value"
        puts "Encryption stream ready for data."
    end

    def write_stream (id, value)
        puts "Writing id #{id}"
        @stdin.print "\n#{id},#{value}"
    end

    def write (id:, value:)
        open_stream unless @stdin
        write_stream(id, value)
    end

    def close
        puts "Closing encryption stream..."
        @stdin.close
        @stdout.close
        @stderr.close 
        puts "Encryption stream closed"

        system "openssl smime -encrypt -binary -in #{@passwordFilename} -out #{@encryptedPasswordFilename} -aes256 #{@publicKeyFilename}"
        puts "Password encrypted as '#{@encryptedPasswordFilename}'"

        File.delete(@passwordFilename)
        puts "Temporary password removed"
    end

end

encryptor = CsvEncrypter.new(
    publicKeyFilename: "public_key.pem",
    encryptedOutputFilename: "output.enc.csv",
    encryptedPasswordFilename: "password.enc.txt"
)

encryptor.write(id: 1, value: "Fabio")
encryptor.write(id: 2, value: "Dave")
encryptor.close 