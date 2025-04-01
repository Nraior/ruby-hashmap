class HashMap
  def initialize(load_factor, capacity)
    @load_factor = load_factor
    @capacity = capacity
    @buckets = Array.new(capacity) { [] }
    @total_items = 0
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
      total_items += 1
    else
      to_update[key] = value
    end
  end

  def handle_extension
    nil unless (@capacity * @load_factor) < total_items
    # Handle extension
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
end
