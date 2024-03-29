# -*- coding: utf-8 -*-
"""Insurance Price prediction.ipynb

Automatically generated by Colaboratory.

Original file is located at
    https://colab.research.google.com/drive/1b9A2wOtq4eV4ZZjmkev9uuw54rR6YMok
"""

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LinearRegression
from sklearn import metrics

data=pd.read_csv('Insurance Data.csv')

data

data.shape

data.head()

data.info()

data.isna().sum()

data.describe()

sns.set()
plt.figure(figsize=(6,6))
sns.distplot(data['age'])
plt.title('Age Distribution')
plt.show()

plt.figure(figsize=(6,6))
sns.countplot(x='sex', data=data)
plt.title('Sex Distribution')
plt.show()

data['sex'].value_counts()

plt.figure(figsize=(6,6))
sns.distplot(data['bmi'])
plt.title('BMI Distribution')
plt.show()

#Normal BMI Range-18.5 to 24.9

data['children'].value_counts()

data['smoker'].value_counts()

data['region'].value_counts()

plt.figure(figsize=(6,6))
sns.distplot(data['charges'])
plt.title('charge Distribution')
plt.show()

#data preprocessing
#sex, smoker and region we need to convert it into numeric(encoding)

data.replace({'sex':{'male':0, 'female':1}},inplace=True)

data.replace({'smoker':{'yes':0, 'no':1}},inplace=True)

data.replace({'region':{'southeast':0, 'southwest':1, 'northeast':2, 'northwest':3}},inplace=True)

data.head()

data.info()

X=data.drop(columns='charges',axis=1)
Y=data['charges']

print(X)

print(Y)

X_train,X_test, Y_train, Y_test=train_test_split(X,Y, test_size=0.2, random_state=2)

print(X.shape, X_train.shape, X_test.shape)

regressor=LinearRegression()

regressor.fit(X_train,Y_train)

training_data_prediction=regressor.predict(X_train)

r2_train=metrics.r2_score(Y_train,training_data_prediction)
print("R Squared val: ", r2_train)

test_data_prediction=regressor.predict(X_test)
r2_test=metrics.r2_score(Y_test,test_data_prediction)
print("R Squared val: ", r2_test)

#Building predictive system:
input_data=(31,1,25.74,0,1,0)

#changing input_data to numpy array
array=np.asarray(input_data)

#reshape the array
input_data_reshaped=array.reshape(1,-1)

prediction=regressor.predict(input_data_reshaped)
print(prediction)

print('The insurance cost is USD', prediction[0])

