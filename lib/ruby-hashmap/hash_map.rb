class HashMap
  attr_reader :buckets, :total_keys, :capacity

  def initialize(load_factor = 0.75, capacity = 16)
    @load_factor = load_factor
    @capacity = capacity
    @buckets = Array.new(capacity) { [] }
    @total_keys = 0
  end

  def get_from_bucket(index)
    raise IndexError if index.negative? || index >= @buckets.length

    @buckets[index]
  end

  def hash(key)
    hash_code = 0
    prime_number = 31

    key.each_char { |char| hash_code = prime_number * hash_code + char.ord }

    hash_code
  end

  def bucket_index(hashed_key)
    bucket_index = hashed_key % @buckets.length
  end

  def set(key, value)
    hashed_key = hash(key)

    # check for collision
    retrieved_value = get_from_bucket(bucket_index(hashed_key))
    # loop through stack
    to_update = retrieved_value.find do |h|
      stack_key = h.keys.first
      stack_key == key
    end

    if to_update.nil?
      retrieved_value.push({ key => value })
      @total_keys += 1

      handle_extension if needs_extension?
    else
      to_update[key] = value
    end
  end

  def handle_extension
    @capacity *= 2
    copied_entries = entries.dup

    clear
    while copied_entries.length > 0
      entry = copied_entries.pop
      set(entry[0], entry[1])
    end
  end

  def needs_extension?
    (@capacity * @load_factor) < @total_keys
  end

  def get(key)
    hashed_key = hash(key)
    bucket = @buckets[bucket_index(hashed_key)]
    bucket.find do |bucket_element|
      bucket_element&.keys&.first == key
    end
  end

  def has?(key)
    !get(key).nil?
  end

  def remove(key)
    hashed_key = hash(key)
    found = get(key)
    return nil unless found

    bucket_index = bucket_index(hashed_key)

    @buckets[bucket_index].delete(found)
    @total_keys -= 1
    found.values.first
  end

  def length
    @total_keys
  end

  def clear
    @total_keys = 0
    @buckets = Array.new(capacity) { [] }
  end

  def keys
    keys = []
    @buckets.map do |bucket|
      bucket.map do |keys_value|
        keys.push(keys_value.keys[0])
      end
    end
    keys.flatten
  end

  def values
    values = []
    @buckets.map do |bucket|
      bucket.map do |keys_value|
        values.push(keys_value.values[0])
      end
    end
    values.flatten
  end

  def entries
    keys.zip(values)
  end
end
