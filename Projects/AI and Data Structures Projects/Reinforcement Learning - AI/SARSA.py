from collections import deque
import gym
import random
import numpy as np
import time
import pickle

from collections import defaultdict


EPISODES =   20000
LEARNING_RATE = .1
DISCOUNT_FACTOR = .99
EPSILON = 1
EPSILON_DECAY = .999



def default_Q_value():
    return 0

def pred(state):
    if random.uniform(0,1) < EPSILON:
        return env.action_space.sample()
    else:
        prediction = np.array([Q_table[(state,i)] for i in range(env.action_space.n)])
        return np.argmax(prediction)


if __name__ == "__main__":


    random.seed(1)
    np.random.seed(1)
    env = gym.envs.make("FrozenLake-v0")
    env.seed(1)
    env.action_space.np_random.seed(1)


    Q_table = defaultdict(default_Q_value) # starts with a pessimistic estimate of zero reward for each state.

    episode_reward_record = deque(maxlen=100)



    for i in range(EPISODES):
        state = env.reset()
        done = False
        action = pred(state)
        while not done:
            next_state,reward,done,info = env.step(action)

            next_action = pred(next_state)

            target = reward + DISCOUNT_FACTOR * Q_table[next_state, next_action]
            Q_table[state, action] += LEARNING_RATE * (target - Q_table[state, action])

            state = next_state
            action = next_action

        episode_reward_record.append(reward)
        EPSILON *= EPSILON_DECAY
        
        
        if i%100 ==0 and i>0:
            print("LAST 100 EPISODE AVERAGE REWARD: " + str(sum(list(episode_reward_record))/100))
            print("EPSILON: " + str(EPSILON) )

    ####DO NOT MODIFY######
    model_file = open('SARSA_Q_TABLE.pkl' ,'wb')
    pickle.dump([Q_table,EPSILON],model_file)
    #######################



