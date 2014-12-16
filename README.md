[![Gem Version](https://badge.fury.io/rb/hipku.svg)](http://badge.fury.io/rb/hipku)

hipku
=====

Hipku – encode any IP address as a haiku


A simple gem to encode/decode IPv4 and IPv6 addresses as/from haiku. A port of http://gabrielmartin.net/projects/hipku/

Usage:

To encode:

    require 'hipku'
    Hipku.encode('127.0.0.1')
    # => "The hungry white ape\naches in the ancient canyon.\nAutumn colors crunch.\n"

To decode:

    require 'hipku'
    Hipku.decode("The hungry white ape\naches in the ancient canyon.\nAutumn colors crunch.\n")
    # => "127.0.0.1"
