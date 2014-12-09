require 'prime'

# an implementation of the Diffie-Hellman key exchange protocol
module OpenSSL

    # p -  prime. g- generator 
    # pub_key - per-session public key matching the private key
    # this needs to be passed to #compute_key.
    # #priv_key - per-session private key
    attr_reader :p, :g, :priv_key

    class DH

        def initialize str="#{p}:#{g}"
            @p, @g = str.split(":").map(&:to_i)
        end

        def priv_key
            @priv_key ||= rand(10) + 1
        end

        def to_der
            "#{p}:#{g}"
        end

        def generate_key!
            @pub_key ||= (g**priv_key) % p
        end

        def compute_key pub_key
            (pub_key ** priv_key) % p
        end

        def p
            @p ||= Prime.each(10**7).to_a.sample
        end

        def g 
            5 # or something else
        end

        def pub_key 
          @pub_key 
        end

    end

end

dh1 = OpenSSL::DH.new
dh1.generate_key!                                      #generate the per-session key pair
der = dh1.to_der                                       #you may send this publicly to the participating party
dh2 = OpenSSL::DH.new(der)
dh2.generate_key!                                      #generate the per-session key pair
symm_key1 = dh1.compute_key(dh2.pub_key)
symm_key2 = dh2.compute_key(dh1.pub_key)

# p dh1.pub_key
# p dh2.pub_key

p symm_key1
puts symm_key1 == symm_key2                            # => true

