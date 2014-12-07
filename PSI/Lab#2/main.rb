require 'openssl'
require 'base64'
require 'securerandom'

SECRET = "s3cr3t"
PUBLIC_KEY_LOC = "public_key.pub"
KEY_LOC = "key.txt"

class Generator

  def initialize
    @rsa = OpenSSL::PKey::RSA.new 2048
    save_public_key
    save_serial
  end

  private

  #'O4KLIVc-5u8C11E-s3cr3t-S9NSu1A-s4qWzcI-lUI9k_0-RV9ETlY
  # "P0X2lPU3OQAsQMIRUaocU3bMn8VAv6cK7xcs3cr3t7rPd4_Y"
  def generate_key
    tmp = (0..5).map { || generate_numbers } << SECRET 
    tmp.shuffle.join
  end

  def generate_numbers
    SecureRandom.urlsafe_base64(5)
  end

  def save_public_key
    File.open(PUBLIC_KEY_LOC, 'w+') { |file| file.write @rsa.public_key.to_pem}
  end

    #encrypt with the private RSA key
    def  encrypted_key
      @rsa.private_encrypt generate_key
    end

    def encoded_key
      Base64.encode64 encrypted_key
    end

    def save_serial
      File.open(KEY_LOC, 'w+') { |file| file.write encoded_key }
    end
end

module Verifier

  class Checker

    def initialize key
      @key = key
      @rsa = OpenSSL::PKey::RSA.new File.read(PUBLIC_KEY_LOC)
    end

    def result
      p decrypted_key
      !(decrypted_key =~ /"#{SECRET}"/)
    end

    private

    def decoded_key
      Base64.decode64 @key
    end

    def decrypted_key 
      @rsa.public_decrypt decoded_key
    end

  end

    def self.verify key
      Checker.new(key).result
    end

end

Generator.new
key = File.open(KEY_LOC, "rb").read
p Verifier.verify key 