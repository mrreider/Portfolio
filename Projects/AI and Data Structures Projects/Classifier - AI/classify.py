import os
import math

#These first two functions require os operations and so are completed for you
#Completed for you
def load_training_data(vocab, directory):
    """ Create the list of dictionaries """
    top_level = os.listdir(directory)
    dataset = []
    for d in top_level:
        if d.startswith('.'):
            # ignore hidden files
            continue
        if d[-1] == '/':
            label = d[:-1]
            subdir = d
        else:
            label = d
            subdir = d+"/"
        files = os.listdir(directory+subdir)
        for f in files:
            bow = create_bow(vocab, directory+subdir+f)
            dataset.append({'label': label, 'bow': bow})
    return dataset

#Completed for you
def create_vocabulary(directory, cutoff):
    """ Create a vocabulary from the training directory
        return a sorted vocabulary list
    """

    top_level = os.listdir(directory)
    vocab = {}
    for d in top_level:
        if d.startswith('.'):
            # ignore hidden files
            continue
        subdir = d if d[-1] == '/' else d+'/'
        files = os.listdir(directory+subdir)
        for f in files:
            with open(directory+subdir+f,'r', encoding='utf-8') as doc:
                for word in doc:
                    word = word.strip()
                    if not word in vocab and len(word) > 0:
                        vocab[word] = 1
                    elif len(word) > 0:
                        vocab[word] += 1
    return sorted([word for word in vocab if vocab[word] >= cutoff])

#The rest of the functions need modifications ------------------------------
#Needs modifications
def create_bow(vocab, filepath):
    bow = {}
    with open(filepath, 'r', encoding='utf-8') as f:
        # For every word, convieniently on every line
        for word in f:
            word = word.strip()
            # If in vocab dict
            if word in vocab:
                # If word not in bow yet
                if word not in bow:     
                    bow[word] = 1
                else:
                    bow[word] += 1
            else:
                if None in bow:
                    bow[None] += 1
                else:
                    bow[None] = 1
    return bow

#Needs modifications
def prior(training_data, label_list):
    """ return the prior probability of the label in the training set
        => frequency of DOCUMENTS
    """
    

    smooth = 1 # smoothing factor
    logprob = {}
    
    num2020 = 0
    num2016 = 0
    for file in training_data:
        if file['label'] == label_list[0]:
            num2020 += 1
        elif file['label'] == label_list[1]:
            num2016 += 1
    
    logprob[label_list[1]] = math.log((num2016 + 1)/(num2016 + num2020 + 2))
    logprob[label_list[0]] = math.log((num2020 + 1)/(num2016 + num2020 + 2))

    return logprob

#Needs modifications
def p_word_given_label(vocab, training_data, label):
    """ return the class conditional probability of label over all words, with smoothing """

    smooth = 1 # smoothing factor
    word_prob = {}

    total_bow = {}
    not_in_label_bow = {}
    total_word_count = 0
    # If the file has the correct label, add all words to total count

    for file in training_data:
        if file['label'] == label:
            for word in file['bow']:

                if word not in total_bow:
                    total_bow[word] = file['bow'][word]
                else:
                    total_bow[word] += file['bow'][word]
                # Add word count to total word count
                total_word_count += file['bow'][word]
        # Not in the correct label find words
        else:
            for word in file['bow']:
                if word not in not_in_label_bow:
                    not_in_label_bow[word] = 1


    for word in total_bow:
        word_prob[word] = math.log((total_bow[word] + smooth*1)/(total_word_count + smooth*(len(vocab) + 1)))
    for word in not_in_label_bow:
        if word in word_prob: continue
        word_prob[word] = math.log((smooth*1)/(total_word_count + smooth*(len(vocab) + 1)))
    if None not in word_prob:
        word_prob[None] = math.log((smooth*1)/(total_word_count + smooth*(len(vocab) + 1)))

    return word_prob


##################################################################################
#Needs modifications
def train(training_directory, cutoff):
    """ return a dictionary formatted as follows:
            {
             'vocabulary': <the training set vocabulary>,
             'log prior': <the output of prior()>,
             'log p(w|y=2016)': <the output of p_word_given_label() for 2016>,
             'log p(w|y=2020)': <the output of p_word_given_label() for 2020>
            }
    """
    retval = {}
    label_list = [f for f in os.listdir(training_directory) if not f.startswith('.')] # ignore hidden files

    vocab = create_vocabulary(training_directory, cutoff)
    training_data = load_training_data(vocab, training_directory)

    retval['vocabulary'] = vocab
    retval['log prior'] = prior(training_data, label_list)
    retval['log p(w|y=2020)'] = p_word_given_label(vocab, training_data, '2020')
    retval['log p(w|y=2016)'] = p_word_given_label(vocab, training_data, '2016')

    return retval

#Needs modifications
def classify(model, filepath):
    """ return a dictionary formatted as follows:
            {
             'predicted y': <'2016' or '2020'>,
             'log p(y=2016|x)': <log probability of 2016 label for the document>,
             'log p(y=2020|x)': <log probability of 2020 label for the document>
            }
    """
    retval = {}
    # Create BOW for specific document
    bow = create_bow(model['vocabulary'], filepath)

    sum_2016 = model['log prior']['2016']
    sum_2020 = model['log prior']['2020']

    for word, occurances in bow.items():
        sum_2016 += model['log p(w|y=2016)'][word] * occurances
        sum_2020 += model['log p(w|y=2020)'][word] * occurances

    retval['log p(y=2020|x)'] = sum_2020
    retval['log p(y=2016|x)'] = sum_2016
    

    retval['predicted y'] = '2016' if sum_2016 > sum_2020 else '2020'
    return retval