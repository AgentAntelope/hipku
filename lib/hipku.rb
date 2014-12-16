require 'hipku/dictionary'

module Hipku
  IPV4_OCTET_COUNT = 4
  IPV6_OCTET_COUNT = 8
  IPV6_PADDING_OCTECT = '0'.freeze
  IPV4_DIVISOR = 16
  IPV6_DIVISOR = 256
  DIVISORS = {
    ipv4: IPV4_DIVISOR,
    ipv6: IPV6_DIVISOR,
  }.freeze
  PLACEHOLDER_OCTET = 'OCTET'

  NEW_LINE = "\n".freeze
  PERIOD = '.'.freeze
  SPACE = ' '.freeze

  FILLER_WORDS = %w[in the and].freeze

  NON_WORDS = [NEW_LINE, PERIOD, SPACE].freeze

  IPV4_HAIKU_STRUCTURE = [
    Dictionary::ANIMAL_ADJECTIVES,
    Dictionary::ANIMAL_COLORS,
    Dictionary::ANIMAL_NOUNS,
    Dictionary::ANIMAL_VERBS,
    Dictionary::NATURE_ADJECTIVES,
    Dictionary::NATURE_NOUNS,
    Dictionary::PLANT_NOUNS,
    Dictionary::PLANT_VERBS,
  ].freeze

  IPV6_HAIKU_STRUCTURE = [
    Dictionary::ADJECTIVES,
    Dictionary::NOUNS,
    Dictionary::ADJECTIVES,
    Dictionary::NOUNS,
    Dictionary::VERBS,
    Dictionary::ADJECTIVES,
    Dictionary::ADJECTIVES,
    Dictionary::ADJECTIVES,
    Dictionary::ADJECTIVES,
    Dictionary::ADJECTIVES,
    Dictionary::NOUNS,
    Dictionary::ADJECTIVES,
    Dictionary::NOUNS,
    Dictionary::VERBS,
    Dictionary::ADJECTIVES,
    Dictionary::NOUNS,
  ].freeze

  HAIKU_STRUCTURE = {
    ipv4: IPV4_HAIKU_STRUCTURE,
    ipv6: IPV6_HAIKU_STRUCTURE,
  }.freeze

  IPV4_SCHEMA = [
    'The',
    PLACEHOLDER_OCTET,
    PLACEHOLDER_OCTET,
    PLACEHOLDER_OCTET,
    NEW_LINE,
    PLACEHOLDER_OCTET,
    'in the',
    PLACEHOLDER_OCTET,
    PLACEHOLDER_OCTET,
    PERIOD,
    NEW_LINE,
    PLACEHOLDER_OCTET,
    PLACEHOLDER_OCTET,
    PERIOD,
    NEW_LINE,
  ].freeze

  IPV6_SCHEMA = [
    PLACEHOLDER_OCTET,
    PLACEHOLDER_OCTET,
    'and',
    PLACEHOLDER_OCTET,
    PLACEHOLDER_OCTET,
    NEW_LINE,
    PLACEHOLDER_OCTET,
    PLACEHOLDER_OCTET,
    PLACEHOLDER_OCTET,
    PLACEHOLDER_OCTET,
    PLACEHOLDER_OCTET,
    PLACEHOLDER_OCTET,
    PLACEHOLDER_OCTET,
    PERIOD,
    NEW_LINE,
    PLACEHOLDER_OCTET,
    PLACEHOLDER_OCTET,
    PLACEHOLDER_OCTET,
    PLACEHOLDER_OCTET,
    PLACEHOLDER_OCTET,
    PERIOD,
    NEW_LINE,
  ].freeze

  SCHEMA = {
    ipv4: IPV4_SCHEMA,
    ipv6: IPV6_SCHEMA,
  }.freeze

  class << self

    def encode(ip)
      @version = ip_version(ip)
      ip = ip.gsub(/[[:space:]]/, '')
      if @version == :ipv6
        octets = split_ipv6(ip)
        # convert from hexidecimal to decimal octets
        octets.map! {|octet| base_convert(octet, 16, 10)}
      elsif @version == :ipv4
        octets = split_ipv4(ip)
      end

      factored_octets = factor_octets(octets, DIVISORS[@version])

      words = encode_words(factored_octets, HAIKU_STRUCTURE[@version])

      write_haiku(words)
    end

    def decode(haiku)
      words = to_word_array(haiku)
      @version = haiku_version(words)
      factors = to_factors(words)

      if @version == :ipv6
        octets = factors
        # convert from decimal to hexidecimal octets
        octets.map! {|octet| base_convert(octet, 10, 16)}
        octets.map! {|octet| octet.size < 2 ? octet.prepend('0') : octet}
        ip = join_ipv6(factors)
      elsif @version == :ipv4
        octets = to_octets(factors)
        ip = join_ipv4(octets)
      end

      ip
    end

    private

    def ip_version(ip)
      case ip
      when /:/
        :ipv6
      when /\./
        :ipv4
      else
        raise "Formatting error in IP Address input (#{ip}). Contains neither ':' or '.'"
      end
    end

    def haiku_version(haiku)
      haiku.each do |word|
        if IPV4_HAIKU_STRUCTURE[0].include?(word)
          return :ipv4
        end
      end

      :ipv6
    end

    def join_ipv4(octets)
      octets.join('.')
    end

    def join_ipv6(octets)
      joined_octets = []
      octets_to_join = []
      octets.each_with_index do |octet, i|
        next if joined_octets.include?(i)
        octets_to_join << [octet, octets[i + 1]].join
        joined_octets << (i + 1)
      end
      octets_to_join.join(':')
    end

    def split_ipv4(ip)
      octets = ip.split('.')
      if octets.size < IPV4_OCTET_COUNT
        raise "Formatting error in IP Address input (#{ip}). IPv4 address has fewer than #{IPV4_OCTET_COUNT} octets."
      end

      octets
    end

    def split_ipv6(ip)
      octets = ip.split(':')

      if octets.size < IPV6_OCTET_COUNT
         pad_octets(octets)
      end

      octets
    end

    def pad_octets(octets)
      if octets.size < IPV6_OCTET_COUNT
        # Double :: at the start, fronr padding
        if octets[0] == '' && octets[1] == ''
          while octets.size < IPV6_OCTET_COUNT
            octets.unshift('')
          end
        else
          while octets.size < IPV6_OCTET_COUNT
            octets.push('')
          end
        end
      end

      if octets.first == ''
        octets[0] = IPV6_PADDING_OCTECT
      end

      if octets.last == ''
        octets[-1] = IPV6_PADDING_OCTECT
      end

      octets.each_with_index do |octet, i|
        if octet == ''
          octets[i] = IPV6_PADDING_OCTECT
        end
      end
      octets
    end

    def base_convert(octet, from, to)
      octet.to_s.to_i(from).to_s(to)
    end

    def factor_octets(octets, divisor)
      octets.map do |octet|
        octet = octet.to_i
        divisor = divisor.to_i
        factor1 = octet / divisor
        factor2 = octet % divisor
        [factor1, factor2]
      end
    end

    def encode_words(factored_octets, structure)
      words = []

      factored_octets.flatten.each_with_index do |octet, i|
        dictionary = structure[i]
        words[i] = dictionary[octet.to_i]
      end

      words
    end

    def write_haiku(word_array)
      placeholder_octet = 'OCTET'
      schema = SCHEMA[@version].dup
      spaces_added = 0
      schema.dup.each_with_index do |schema_part, i|
        if add_space?(schema_part) && schema[i + spaces_added - 1] != NEW_LINE
          schema.insert(i + spaces_added, SPACE);
          spaces_added += 1
        end
      end

      placeholder_octet_counter = 0
      haiku_array = schema.map do |schema_part|
        if schema_part == PLACEHOLDER_OCTET
          word_array[placeholder_octet_counter].tap { placeholder_octet_counter +=1 }
        else
          schema_part
        end
      end

      capitalize_words(haiku_array).join
    end

    def add_space?(candidate)
      !NON_WORDS.include?(candidate)
    end

    def to_word_array(haiku)
      haiku = haiku.downcase
      haiku.gsub!(/\n/, ' ')
      haiku.gsub!(/[^a-z\ -]/, '');
      word_array = haiku.split(' ');
      word_array.reject!{|word| word == '' || FILLER_WORDS.include?(word)}
      word_array
    end

    def to_factors(words)
      factors = []
      skipped_indexes = []
      words_passed = 0

      words.each_with_index do |word, i|
        next if skipped_indexes.include?(i)

        dictionary = HAIKU_STRUCTURE[@version][words_passed]

        dictionary.each do |dictionary_word|
          extra_words = dictionary_word.split(' ').count
          word_to_check = words.slice(i, extra_words).join(' ')
          if dictionary.index(word_to_check)
            factors << dictionary.index(word_to_check)
            words_passed += 1

            if extra_words > 1
              while extra_words > 1 do
                skipped_indexes << i + extra_words -=1
              end
            end

            break
          end
        end
      end

      factors
    end

    def to_octets(factors)
      octets = []
      ignored_factors = []

      factors.each_with_index do |factor, i|
        next if ignored_factors.include?(i)
        octets << (DIVISORS[@version] * factor) + factors[(i+1)]
        ignored_factors << (i + 1)
      end

      octets
    end

    def capitalize_words(haiku_array)

      haiku_array[0] = haiku_array.first.capitalize

      haiku_array.each_with_index do |haiku_part, i|
        if haiku_part == PERIOD
          if haiku_array[i + 2] && !NON_WORDS.include?(haiku_array[i + 2])
            haiku_array[i + 2] = haiku_array[i + 2].capitalize
          end
        end
      end
    end
  end
end
