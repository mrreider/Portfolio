import heapq
import math

# added optional parameter to return sucessors
def print_succ(state, ret=False):
    successors = []
    index = state.index(0)
    x = index % 3
    y = math.floor(index / 3)
    # Corner
    if ((index % 3 == 0 or index % 3 == 2) and (math.floor(index / 3) == 0 or math.floor(index / 3) == 2)):
        copy1 = state.copy()
        copy2 = state.copy()
        # If top row
        if (math.floor(index / 3) == 0):
            # If left
            if (index % 3 == 0):
                swap(copy1,0,1)
                swap(copy2,0,3)
            # Right
            else:
                swap(copy1,2,1)
                swap(copy2,2,5)
        # Bottom row
        else:
            # Left
            if (index % 3 == 0):
                swap(copy1,6,7)
                swap(copy2,6,3)
            # Right
            else:
                swap(copy1,8,7)
                swap(copy2,8,5)
        successors.append(copy1)
        successors.append(copy2)
    # Center
    elif (index % 3 == 1 and math.floor(index / 3) == 1):
        copy1 = state.copy()
        copy2 = state.copy()
        copy3 = state.copy()
        copy4 = state.copy()
        swap(copy1,4,1)
        swap(copy2,4,3)
        swap(copy3,4,5)
        swap(copy4,4,7)
        successors.append(copy1)
        successors.append(copy2)
        successors.append(copy3)
        successors.append(copy4)
    # Middle boundary
    else:
        copy1 = state.copy()
        copy2 = state.copy()
        copy3 = state.copy()
        # Top
        if (math.floor(index / 3) == 0):
            swap(copy1,1, 0)
            swap(copy2,1, 2)
            swap(copy3,1, 4)
        # Middle left
        elif(index % 3 == 0):
            swap(copy1,3,0)
            swap(copy2,3,4)
            swap(copy3,3,6)
        # Middle right
        elif(index % 3 == 2):
            swap(copy1,5,2)
            swap(copy2,5,4)
            swap(copy3,5,8)
        # Bottom middle
        else:
            swap(copy1,7,4)
            swap(copy2,7,6)
            swap(copy3,7,8)
        successors.append(copy1)
        successors.append(copy2)
        successors.append(copy3)
    # Print with manhattan distance
    successors.sort()
    if (ret):
        return successors
    else:
        for succ in successors:
            print(f'{succ} h={get_manhattan_heuristic(succ)}')

def solve(state):
    pq = []
    closed = []
    visited = set()
    # place start node
    heapq.heappush(pq,(get_manhattan_heuristic(state), state, (0,get_manhattan_heuristic(state),-1)))

    # While pq has entries
    while (pq):
        n = heapq.heappop(pq)
        closed.append(n)

        # Goal State
        if (n[1] == [1,2,3,4,5,6,7,8,0]):
            break

        visited.add(tuple(n[1]))

        # Iterate on successors
        succ = print_succ(n[1], ret=True)
        for s in succ:
            if (tuple(s) in visited):
                continue
            h = get_manhattan_heuristic(s)
            successor = (h + n[2][0] + 1, s, (n[2][0] + 1,h, len(closed) -1) )
            heapq.heappush(pq, successor)
        
        ret_path = []

    parent = len(closed) - 2
    child = parent + 1

    # Iterate back to make path
    while parent != -1:
        ret_path.append(closed[child])
        child = parent
        # get next parent node
        parent = closed[parent][2][2]
    
    ret_path.append(closed[child])

    # Print from end
    for i in range(len(ret_path)):
        p = ret_path[len(ret_path) - 1 - i]
        print(f'{p[1]} h={p[2][1]} moves: {p[2][0]}')

        
def get_manhattan_heuristic(state):
    sum = 0
    for i in range(len(state)):
        # Each index should contain the number one higher than it
        x = i % 3
        y = math.floor(i / 3)
        if (state[i] != 0):
        # All other tiles should be at [value - 1 % 3, value - 1 / 3]
            sum += abs(x - ((state[i] - 1 ) % 3)) + abs(y - math.floor((state[i] - 1) / 3))
        # Except zero, which goes after 8 at index 8
    return sum

def swap(arr, i1, i2):
    arr[i1], arr[i2] = arr[i2], arr[i1]