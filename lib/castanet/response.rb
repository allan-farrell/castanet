
# line 1 "lib/castanet/response.rl"
require 'castanet'


# line 73 "lib/castanet/response.rl"


module Castanet
  class Response
    ##
    # Whether or not this response passed CAS authentication.
    #
    # @return [Boolean]
    attr_accessor :authenticated

    alias_method :authenticated?, :authenticated

    ##
    # The failure code returned on authentication failure.
    #
    # @return [String, nil]
    attr_accessor :failure_code

    ##
    # The reason given by the CAS server for authentication failure.
    #
    # @return [String, nil]
    attr_accessor :failure_reason

    ##
    # The name of the owner of the validated service or proxy ticket.
    #
    # This information is only present on authentication success.
    #
    # @return [String, nil]
    attr_accessor :username

    ##
    # Generates a {Response} object from a CAS response.
    #
    # @param [String] response the CAS response
    # @return [Response]
    def self.from_cas(response)
      data = response.strip.unpack('c*')
      buffer = ''
      eof = nil

      
# line 51 "lib/castanet/response.rb"
begin
	p ||= 0
	pe ||= data.length
	cs = parser_start
end

# line 116 "lib/castanet/response.rl"

      new.tap do |r|
        
# line 62 "lib/castanet/response.rb"
begin
	_klen, _trans, _keys, _acts, _nacts = nil
	_goto_level = 0
	_resume = 10
	_eof_trans = 15
	_again = 20
	_test_eof = 30
	_out = 40
	while true
	_trigger_goto = false
	if _goto_level <= 0
	if p == pe
		_goto_level = _test_eof
		next
	end
	if cs == 0
		_goto_level = _out
		next
	end
	end
	if _goto_level <= _resume
	_keys = _parser_key_offsets[cs]
	_trans = _parser_index_offsets[cs]
	_klen = _parser_single_lengths[cs]
	_break_match = false
	
	begin
	  if _klen > 0
	     _lower = _keys
	     _upper = _keys + _klen - 1

	     loop do
	        break if _upper < _lower
	        _mid = _lower + ( (_upper - _lower) >> 1 )

	        if data[p] < _parser_trans_keys[_mid]
	           _upper = _mid - 1
	        elsif data[p] > _parser_trans_keys[_mid]
	           _lower = _mid + 1
	        else
	           _trans += (_mid - _keys)
	           _break_match = true
	           break
	        end
	     end # loop
	     break if _break_match
	     _keys += _klen
	     _trans += _klen
	  end
	  _klen = _parser_range_lengths[cs]
	  if _klen > 0
	     _lower = _keys
	     _upper = _keys + (_klen << 1) - 2
	     loop do
	        break if _upper < _lower
	        _mid = _lower + (((_upper-_lower) >> 1) & ~1)
	        if data[p] < _parser_trans_keys[_mid]
	          _upper = _mid - 2
	        elsif data[p] > _parser_trans_keys[_mid+1]
	          _lower = _mid + 2
	        else
	          _trans += ((_mid - _keys) >> 1)
	          _break_match = true
	          break
	        end
	     end # loop
	     break if _break_match
	     _trans += _klen
	  end
	end while false
	cs = _parser_trans_targs[_trans]
	if _parser_trans_actions[_trans] != 0
		_acts = _parser_trans_actions[_trans]
		_nacts = _parser_actions[_acts]
		_acts += 1
		while _nacts > 0
			_nacts -= 1
			_acts += 1
			case _parser_actions[_acts - 1]
when 0 then
# line 9 "lib/castanet/response.rl"
		begin
 buffer << data[p] 		end
when 1 then
# line 10 "lib/castanet/response.rl"
		begin
 r.username = buffer; buffer = '' 		end
when 2 then
# line 11 "lib/castanet/response.rl"
		begin
 r.failure_code = buffer; buffer = '' 		end
when 3 then
# line 12 "lib/castanet/response.rl"
		begin
 r.failure_reason = buffer.strip; buffer = '' 		end
when 4 then
# line 13 "lib/castanet/response.rl"
		begin
 r.authenticated = true; eof = -1 		end
# line 162 "lib/castanet/response.rb"
			end # action switch
		end
	end
	if _trigger_goto
		next
	end
	end
	if _goto_level <= _again
	if cs == 0
		_goto_level = _out
		next
	end
	p += 1
	if p != pe
		_goto_level = _resume
		next
	end
	end
	if _goto_level <= _test_eof
	end
	if _goto_level <= _out
		break
	end
	end
	end

# line 119 "lib/castanet/response.rl"
      end
    end

    def initialize
      self.authenticated = false
    end

    
# line 198 "lib/castanet/response.rb"
class << self
	attr_accessor :_parser_actions
	private :_parser_actions, :_parser_actions=
end
self._parser_actions = [
	0, 1, 0, 1, 1, 1, 2, 1, 
	3, 1, 4
]

class << self
	attr_accessor :_parser_key_offsets
	private :_parser_key_offsets, :_parser_key_offsets=
end
self._parser_key_offsets = [
	0, 0, 1, 2, 3, 4, 5, 6, 
	7, 8, 9, 10, 11, 12, 13, 14, 
	15, 16, 17, 18, 19, 20, 21, 22, 
	23, 24, 25, 26, 27, 28, 29, 30, 
	31, 33, 34, 35, 36, 37, 38, 39, 
	40, 41, 42, 43, 44, 45, 46, 47, 
	48, 49, 50, 51, 52, 53, 54, 55, 
	56, 57, 58, 59, 61, 62, 66, 67, 
	68, 69, 70, 71, 72, 73, 74, 75, 
	76, 77, 78, 79, 80, 81, 82, 83, 
	84, 86, 87, 88, 89, 90, 91, 92, 
	93, 94, 95, 96, 97, 98, 100, 103, 
	108, 109, 111, 113, 114, 115, 116, 117, 
	118, 119, 120, 121, 122, 123, 124, 125, 
	126, 127, 128, 129, 130, 131, 132, 133, 
	134, 135, 136, 137, 138, 139, 140, 144, 
	145, 146, 147, 148, 149, 150, 151, 152, 
	153, 154, 155, 156, 157, 158, 159, 160, 
	161, 162, 163, 164, 165, 166, 167, 168, 
	169, 170, 171, 172, 176, 177, 178, 179, 
	180, 181, 182, 183, 184, 185, 187, 189, 
	190, 191, 192, 193, 194, 195, 196, 197, 
	198, 199, 203, 204, 205, 206, 207, 208, 
	209, 210, 211, 212, 213, 214, 215, 216, 
	217, 218, 219, 220, 221, 222, 223, 224, 
	225, 226, 227, 228, 229, 230, 234, 235, 
	236, 237, 238, 239, 240, 241, 242, 243, 
	244, 245, 246, 247, 248, 249, 250, 251, 
	252, 253, 254, 255
]

class << self
	attr_accessor :_parser_trans_keys
	private :_parser_trans_keys, :_parser_trans_keys=
end
self._parser_trans_keys = [
	60, 99, 97, 115, 58, 115, 101, 114, 
	118, 105, 99, 101, 82, 101, 115, 112, 
	111, 110, 115, 101, 32, 120, 109, 108, 
	110, 115, 58, 99, 97, 115, 61, 34, 
	39, 104, 116, 116, 112, 58, 47, 47, 
	119, 119, 119, 46, 121, 97, 108, 101, 
	46, 101, 100, 117, 47, 116, 112, 47, 
	99, 97, 115, 34, 39, 62, 32, 60, 
	9, 13, 99, 97, 115, 58, 97, 117, 
	116, 104, 101, 110, 116, 105, 99, 97, 
	116, 105, 111, 110, 70, 83, 97, 105, 
	108, 117, 114, 101, 32, 99, 111, 100, 
	101, 61, 34, 39, 95, 65, 90, 34, 
	39, 95, 65, 90, 62, 38, 60, 38, 
	60, 47, 99, 97, 115, 58, 97, 117, 
	116, 104, 101, 110, 116, 105, 99, 97, 
	116, 105, 111, 110, 70, 97, 105, 108, 
	117, 114, 101, 62, 32, 60, 9, 13, 
	47, 99, 97, 115, 58, 115, 101, 114, 
	118, 105, 99, 101, 82, 101, 115, 112, 
	111, 110, 115, 101, 62, 117, 99, 99, 
	101, 115, 115, 62, 32, 60, 9, 13, 
	99, 97, 115, 58, 117, 115, 101, 114, 
	62, 38, 60, 38, 60, 47, 99, 97, 
	115, 58, 117, 115, 101, 114, 62, 32, 
	60, 9, 13, 47, 99, 97, 115, 58, 
	97, 117, 116, 104, 101, 110, 116, 105, 
	99, 97, 116, 105, 111, 110, 83, 117, 
	99, 99, 101, 115, 115, 62, 32, 60, 
	9, 13, 47, 99, 97, 115, 58, 115, 
	101, 114, 118, 105, 99, 101, 82, 101, 
	115, 112, 111, 110, 115, 101, 62, 0
]

class << self
	attr_accessor :_parser_single_lengths
	private :_parser_single_lengths, :_parser_single_lengths=
end
self._parser_single_lengths = [
	0, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	2, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 2, 1, 2, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	2, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 2, 1, 3, 
	1, 2, 2, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 2, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 2, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 2, 2, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 2, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 2, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 0
]

class << self
	attr_accessor :_parser_range_lengths
	private :_parser_range_lengths, :_parser_range_lengths=
end
self._parser_range_lengths = [
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 1, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 1, 1, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 1, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 1, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 1, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 1, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0
]

class << self
	attr_accessor :_parser_index_offsets
	private :_parser_index_offsets, :_parser_index_offsets=
end
self._parser_index_offsets = [
	0, 0, 2, 4, 6, 8, 10, 12, 
	14, 16, 18, 20, 22, 24, 26, 28, 
	30, 32, 34, 36, 38, 40, 42, 44, 
	46, 48, 50, 52, 54, 56, 58, 60, 
	62, 65, 67, 69, 71, 73, 75, 77, 
	79, 81, 83, 85, 87, 89, 91, 93, 
	95, 97, 99, 101, 103, 105, 107, 109, 
	111, 113, 115, 117, 120, 122, 126, 128, 
	130, 132, 134, 136, 138, 140, 142, 144, 
	146, 148, 150, 152, 154, 156, 158, 160, 
	162, 165, 167, 169, 171, 173, 175, 177, 
	179, 181, 183, 185, 187, 189, 192, 195, 
	200, 202, 205, 208, 210, 212, 214, 216, 
	218, 220, 222, 224, 226, 228, 230, 232, 
	234, 236, 238, 240, 242, 244, 246, 248, 
	250, 252, 254, 256, 258, 260, 262, 266, 
	268, 270, 272, 274, 276, 278, 280, 282, 
	284, 286, 288, 290, 292, 294, 296, 298, 
	300, 302, 304, 306, 308, 310, 312, 314, 
	316, 318, 320, 322, 326, 328, 330, 332, 
	334, 336, 338, 340, 342, 344, 347, 350, 
	352, 354, 356, 358, 360, 362, 364, 366, 
	368, 370, 374, 376, 378, 380, 382, 384, 
	386, 388, 390, 392, 394, 396, 398, 400, 
	402, 404, 406, 408, 410, 412, 414, 416, 
	418, 420, 422, 424, 426, 428, 432, 434, 
	436, 438, 440, 442, 444, 446, 448, 450, 
	452, 454, 456, 458, 460, 462, 464, 466, 
	468, 470, 472, 474
]

class << self
	attr_accessor :_parser_trans_targs
	private :_parser_trans_targs, :_parser_trans_targs=
end
self._parser_trans_targs = [
	2, 0, 3, 0, 4, 0, 5, 0, 
	6, 0, 7, 0, 8, 0, 9, 0, 
	10, 0, 11, 0, 12, 0, 13, 0, 
	14, 0, 15, 0, 16, 0, 17, 0, 
	18, 0, 19, 0, 20, 0, 21, 0, 
	22, 0, 23, 0, 24, 0, 25, 0, 
	26, 0, 27, 0, 28, 0, 29, 0, 
	30, 0, 31, 0, 32, 0, 33, 33, 
	0, 34, 0, 35, 0, 36, 0, 37, 
	0, 38, 0, 39, 0, 40, 0, 41, 
	0, 42, 0, 43, 0, 44, 0, 45, 
	0, 46, 0, 47, 0, 48, 0, 49, 
	0, 50, 0, 51, 0, 52, 0, 53, 
	0, 54, 0, 55, 0, 56, 0, 57, 
	0, 58, 0, 59, 0, 60, 60, 0, 
	61, 0, 61, 62, 61, 0, 63, 0, 
	64, 0, 65, 0, 66, 0, 67, 0, 
	68, 0, 69, 0, 70, 0, 71, 0, 
	72, 0, 73, 0, 74, 0, 75, 0, 
	76, 0, 77, 0, 78, 0, 79, 0, 
	80, 0, 81, 148, 0, 82, 0, 83, 
	0, 84, 0, 85, 0, 86, 0, 87, 
	0, 88, 0, 89, 0, 90, 0, 91, 
	0, 92, 0, 93, 0, 94, 94, 0, 
	95, 95, 0, 96, 96, 95, 95, 0, 
	97, 0, 0, 0, 98, 0, 99, 98, 
	100, 0, 101, 0, 102, 0, 103, 0, 
	104, 0, 105, 0, 106, 0, 107, 0, 
	108, 0, 109, 0, 110, 0, 111, 0, 
	112, 0, 113, 0, 114, 0, 115, 0, 
	116, 0, 117, 0, 118, 0, 119, 0, 
	120, 0, 121, 0, 122, 0, 123, 0, 
	124, 0, 125, 0, 126, 0, 126, 127, 
	126, 0, 128, 0, 129, 0, 130, 0, 
	131, 0, 132, 0, 133, 0, 134, 0, 
	135, 0, 136, 0, 137, 0, 138, 0, 
	139, 0, 140, 0, 141, 0, 142, 0, 
	143, 0, 144, 0, 145, 0, 146, 0, 
	147, 0, 227, 0, 149, 0, 150, 0, 
	151, 0, 152, 0, 153, 0, 154, 0, 
	155, 0, 155, 156, 155, 0, 157, 0, 
	158, 0, 159, 0, 160, 0, 161, 0, 
	162, 0, 163, 0, 164, 0, 165, 0, 
	0, 0, 166, 0, 167, 166, 168, 0, 
	169, 0, 170, 0, 171, 0, 172, 0, 
	173, 0, 174, 0, 175, 0, 176, 0, 
	177, 0, 177, 178, 177, 0, 179, 0, 
	180, 0, 181, 0, 182, 0, 183, 0, 
	184, 0, 185, 0, 186, 0, 187, 0, 
	188, 0, 189, 0, 190, 0, 191, 0, 
	192, 0, 193, 0, 194, 0, 195, 0, 
	196, 0, 197, 0, 198, 0, 199, 0, 
	200, 0, 201, 0, 202, 0, 203, 0, 
	204, 0, 205, 0, 205, 206, 205, 0, 
	207, 0, 208, 0, 209, 0, 210, 0, 
	211, 0, 212, 0, 213, 0, 214, 0, 
	215, 0, 216, 0, 217, 0, 218, 0, 
	219, 0, 220, 0, 221, 0, 222, 0, 
	223, 0, 224, 0, 225, 0, 226, 0, 
	227, 0, 0, 0
]

class << self
	attr_accessor :_parser_trans_actions
	private :_parser_trans_actions, :_parser_trans_actions=
end
self._parser_trans_actions = [
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	1, 1, 0, 5, 5, 1, 1, 0, 
	0, 0, 0, 0, 1, 0, 7, 1, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 1, 0, 3, 1, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	9, 0, 0, 0
]

class << self
	attr_accessor :parser_start
end
self.parser_start = 1;
class << self
	attr_accessor :parser_first_final
end
self.parser_first_final = 227;
class << self
	attr_accessor :parser_error
end
self.parser_error = 0;

class << self
	attr_accessor :parser_en_main
end
self.parser_en_main = 1;


# line 127 "lib/castanet/response.rl"
  end
end