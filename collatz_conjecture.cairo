%builtins range_check
from starkware.cairo.common.math_cmp import is_nn_le, is_nn


func main{range_check_ptr}():
  iterate(num=987654321, iter=1, cap=1000)
  return ()
end


# For any positive integer `num`,
# if `num` is even: divide `num` by 2
# else: multiply `num` by 3 and add 1
#
# Integers tested up to 2^68 result in a (4, 2, 1) loop
# but we cannot mathematically prove that all integers will
func iterate{range_check_ptr}(num : felt, iter : felt, cap : felt):
  alloc_locals

  let (cap_reached) = is_nn(iter - cap)
  let (num_is_one) = is_nn_le(num, 1)
  let bail = cap_reached + num_is_one
  if bail != 0:
    return ()
  end
  
  local half = num / 2
  let (even) = is_nn(half)

  local num_new
  if even == 1:
    num_new = half
  else:
    tempvar three_x = num * 3
    num_new = three_x + 1
  end

  %{ print(f'{ids.iter}:', ids.num_new) %}
  return iterate(num=num_new, iter=iter+1, cap=cap)
end
