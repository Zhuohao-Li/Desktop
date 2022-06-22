from problem import Direction


class SearchAlgorithm:
    def __init__(self, algo_name):
        assert algo_name in ["tiny", "bfs", "dfs"], "Invalid algorithm."

        if algo_name == "tiny":
            self._solver = tiny_maze_search
        elif algo_name == "bfs":
            self._solver = breadth_first_search
        elif algo_name == "dfs":
            self._solver = depth_first_search

    def __call__(self, problem):
        return self._solver(problem)


def tiny_maze_search(problem):
    """Returns a sequence of moves that solves tinyMaze."""
    s = Direction.SOUTH
    w = Direction.WEST
    return [s, s, w, s, w, w, s, w]


def depth_first_search(problem):
    """Returns a sequence of moves that solves general maze problems with DFS.

    Search the deepest nodes in the search tree first.

    Your search algorithm needs to return a list of actions that reaches the
    goal. To get started, you might leverage your Stack structure and the APIs
    provided in the Problem class:

    print("Start:", problem.get_start())
    print("Is the start a goal?", problem.is_goal(problem.get_start()))
    print("Start's successors:", problem.get_successors(problem.get_start()))
    """
    from util import Stack

    """ YOUR CODE HERE """

    s = Stack()
    initial_state = problem.get_start()
    s.push(initial_state)

    '''initialize stack with start state by pushing it into the stack'''
    marked = [initial_state]
    '''mark nodes that have been tested before'''

    '''
    this is a log part
    '''
    # parent=[]
    # print(problem.is_goal(state))
    # print(s.is_empty())

    # tutles =problem.get_successors(initial_state)
    # print(tutles[0])
    # a,*_ = tutles[0]
    # print(a)

    # print(s.is_empty())
    # state = s.pop()
    # print (state)
    # print (marked)
    # print(s.is_empty())
    # print(problem.is_goal(state))
    path = []

    while s.is_empty() == False:
        state = s.pop()
        path.append(state)
        # print(state)
        #parent.append(state)
        if problem.is_goal(state):
            print(path)
            return None
        else:
            tuples = problem.get_successors(state)
            # tuples is ((X,x,x),(X,x,x),(x,x,x),...)
            for i in range(len(tuples)):
                a, *_ = tuples[i]
                state = a
                if state not in marked:
                    marked.append(state)
                    s.push(state)

            # a,*_=tuples[0]
            # # (X,x,x)
            # state = a
            # # a is X = (x,x)
            # if state not in marked:
            #     marked.add(state)
            #     s.push(state)
    else:
        return None


def breadth_first_search(problem):
    """Returns a sequence of moves that solves general maze problems with BFS.

    Search the shallowest nodes in the search tree first.
    """
    from util import Queue

    """ YOUR CODE HERE """
    q = Queue()
    initial_state = problem.get_start()
    q.push(initial_state)
    marked = [initial_state]
    path=[]

    while q.is_empty() == False:
        state = q.pop()
        path.append(state)
        #print(state)
        if problem.is_goal(state):
            print(path)
            return None
        else:
            tuples = problem.get_successors(state)
            for i in range(len(tuples)):
                a, *_ = tuples[i]
                state = a
                if state not in marked:
                    marked.append(state)
                    q.push(state)

    else:
        print("Failure")
        return None

    # return []
