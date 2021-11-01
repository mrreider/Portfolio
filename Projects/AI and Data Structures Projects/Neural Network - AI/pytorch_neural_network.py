import torch
import torch.nn as nn
import torch.nn.functional as F
import torch.optim as optim
from torch.utils.data import DataLoader
from torchvision import datasets, transforms
import numpy as np
def get_data_loader(training = True):
    custom_transform= transforms.Compose([
        transforms.ToTensor(),
        transforms.Normalize((0.1307,), (0.3081,))
        ])

    train_set = datasets.MNIST('./data', train=True, download=True,
                       transform=custom_transform)

    test_set = datasets.MNIST('./data', train=False,
                       transform=custom_transform)
    
    training_loader = DataLoader(train_set, batch_size=50)
    testing_loader = DataLoader(test_set, batch_size=50, shuffle=False)

    return training_loader if training else testing_loader

def build_model():
    model = nn.Sequential(
        nn.Flatten(),
        nn.Linear(784, 128),
        nn.ReLU(),
        nn.Linear(128, 64,),
        nn.ReLU(),
        nn.Linear(64,10)
    )
    return model

def train_model(model, train_loader, criterion, T):
    model.train()
    opt = optim.SGD(model.parameters(), lr=0.001, momentum=0.9)

    for epoch in range(T):
        running_loss = 0.0
        correct = 0
        total = 0
        for i, data in enumerate(train_loader, 0):
            input, label = data

            opt.zero_grad()
            outputs = model(input)
            loss = criterion(outputs, label)
            loss.backward()
            opt.step()

            _, predicted = torch.max(outputs.data, 1)
            total += label.size(0)
            correct += (predicted == label).sum().item()

            running_loss += loss.item()
        perc = "{:.2%}".format(correct/total)
        perc_loss = "{:.3}".format(running_loss/i)
        print(f'Train Epoch: {epoch} Accuracy: {correct}/{total}({perc}) Loss: {perc_loss}')

def evaluate_model(model, test_loader, criterion, show_loss = True):
    model.eval()
    correct = 0
    total = 0
    running_loss = 0.0
    with torch.no_grad():
        for data in test_loader:
            images, labels = data
            outputs = model(images)
            loss = criterion(outputs, labels)
            running_loss += loss.item()
            _, predicted = torch.max(outputs.data, 1)
            total += labels.size(0)
            correct += (predicted == labels).sum().item()
    av_loss = "{:.4f}".format(loss/len(test_loader.dataset))       
    acc =  "{:.2%}".format(correct/total)
    if show_loss:
        print(f'Average Loss: {av_loss}')
    print(f'Accuracy: {acc}')

def predict_label(model, test_images, index):

    class_names = ['zero', 'one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine']
    for data in test_images:
        images, labels = data
        break

    logits = model(images[index])[0]
    prob = F.softmax(logits, dim=0)

    maxs = []
    for x in range(3):
        max_index = torch.argmax(prob)
        maxs.append(("{:.2%}".format(prob[max_index]), max_index))
        prob[max_index] = 0.0


    print(f'{class_names[maxs[0][1]]}: {maxs[0][0]}')
    print(f'{class_names[maxs[1][1]]}: {maxs[1][0]}')
    print(f'{class_names[maxs[2][1]]}: {maxs[2][0]}')

if __name__ == "__main__":
    pass



