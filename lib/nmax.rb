require "nmax/version"

module Nmax
  CHUNK_SIZE = 1_000_000
  MAX_DIGITS = 1000

  def self.find_numbers(stream, numbers_count)
    return if stream.tty? || numbers_count < 1

    result = {}
    last_number = ''

    while chunk = stream.read(CHUNK_SIZE)
      chunk = last_number + chunk
      new_last_number = chunk.match(/\d+\z/).to_s

      end_size = chunk.size - new_last_number.size - 1
      if end_size > 0
        chunk[0..end_size].scan(/\d+/).uniq.each do |n|
          insert_number(result, n, numbers_count)
        end
      end

      last_number = new_last_number
    end

    insert_number(result, last_number, numbers_count) if last_number != ''

    result.map { |k,v| k }.max(numbers_count)
  end

  private

  def self.insert_number(result, number, numbers_count)
    return if number.size > MAX_DIGITS

    num = number.to_i
    if result.size == numbers_count
      min = result.min.first
      if num > min
        result.delete(min)
        result[num] = nil
      end
    else
      result[num] = nil
    end
  end
end
