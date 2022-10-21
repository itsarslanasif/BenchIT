# refer : https://redis.io/commands

module Redis::Alfred
  include Redis::RedisKeys

  class << self
    # key operations

    # set a value in redis
    def set(key, value)
      $alfred.set(key, value)
    end

    # set a key with expiry period
    def setex(key, value, expiry = 1.day)
      $alfred.setex(key, expiry, value)
    end

    def get(key)
      $alfred.get(key)
    end

    def delete(key)
      $alfred.del(key)
    end

    # increment a key by 1. throws error if key value is incompatible
    # sets key to 0 before operation if key doesn't exist
    def incr(key)
      $alfred.incr(key)
    end

    # list operations

    def llen(key)
      $alfred.llen(key)
    end

    def lrange(key, start_index = 0, end_index = -1)
      $alfred.lrange(key, start_index, end_index)
    end

    def rpop(key)
      $alfred.rpop(key)
    end

    def lpush(key, values)
      $alfred.lpush(key, values)
    end

    def rpoplpush(source, destination)
      $alfred.rpoplpush(source, destination)
    end

    def lrem(key, value, count = 0)
      $alfred.lrem(key, count, value)
    end

    # hash operations

    # add a key value to redis hash
    def hset(key, field, value)
      $alfred.hset(key, field, value)
    end

    # get value from redis hash
    def hget(key, field)
      $alfred.hget(key, field)
    end

    # get values of multiple keys from redis hash
    def hmget(key, fields)
      $alfred.hmget(key, *fields)
    end

    # sorted set operations

    # add score and value for a key
    def zadd(key, score, value)
      $alfred.zadd(key, score, value)
    end

    # get score of a value for key
    def zscore(key, value)
      $alfred.zscore(key, value)
    end

    # get values by score
    def zrangebyscore(key, range_start, range_end)
      $alfred.zrangebyscore(key, range_start, range_end)
    end

    # remove values by score
    # exclusive score is specified by prefixing (
    def zremrangebyscore(key, range_start, range_end)
      $alfred.zremrangebyscore(key, range_start, range_end)
    end
  end
end
