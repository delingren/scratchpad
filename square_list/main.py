class entry:
    def __init__(self, current, remaining, lastTried):
        self.current = current
        self.remaining = remaining
        self.lastTried = lastTried

def solve(size):
    possibleSquares = [x*x for x in range(2, size+1) if x*x < size*2]
    for first in range(1, size+1):
        stack = [entry([first], [x for x in range(1, size+1) if x != first], 0)]
        while len(stack) > 0:
            top = stack[-1]
            if len(top.remaining) == 0:
                print(top.current)
                return
            next = None
            for n in top.remaining:
                if n > top.lastTried and (top.current[-1]+n) in possibleSquares:
                    next = n
                    break
            if next == None:
                stack.pop()
            else:
                top.lastTried = next
                stack.append(entry(top.current + [next], [n for n in top.remaining if n != next], 0))

# for i in range(100):
#     print("size: ", i)
#     solve(i)

solve(15)