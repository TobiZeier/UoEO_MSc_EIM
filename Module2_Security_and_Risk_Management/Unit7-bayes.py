#2.3. Bayes Tables
import pandas as pd

table = pd.DataFrame(index=['Bowl 1', 'Bowl 2'])

table['prior'] = 1 / 2, 1 / 2
table['likelihood'] = 3 / 4, 1 / 2
table['unnorm'] = table['prior'] * table['likelihood']
#print(table)

prob_data = table['unnorm'].sum()
#print(prob_data)

table['posterior'] = table['unnorm'] / prob_data
#print(table)

#2.4. The Dice Problem
table2 = pd.DataFrame(index=[6, 8, 12])

from fractions import Fraction

table2['prior'] = Fraction(1, 3)
table2['likelihood'] = Fraction(1, 6), Fraction(1, 8), Fraction(1, 12)


def update(table):
    """Compute the posterior probabilities."""
    table['unnorm'] = table['prior'] * table['likelihood']
    prob_data = table['unnorm'].sum()
    table['posterior'] = table['unnorm'] / prob_data
    return prob_data


prob_data = update(table2)

#print(table2)

#2.5. The Monty Hall Problem
table3 = pd.DataFrame(index=['Door 1', 'Door 2', 'Door 3'])
table3['prior'] = Fraction(1, 3)
table3['likelihood'] = Fraction(1, 2), 1, 0
update(table3)

#print(table3)

#2.7 Exercises
table4 = pd.DataFrame(index=['Normal', 'Trick'])
table4['prior'] = 1/2
table4['likelihood'] = 1/2, 1

update(table4)
#print(table4)

table5 = pd.DataFrame(index=['GG', 'GB', 'BG', 'BB'])
table5['prior'] = 1/4
table5['likelihood'] = 1, 1, 1, 0

update(table5)
#print(table5)

# Hypotheses:
# A: yellow from 94, green from 96
# B: yellow from 96, green from 94
table8 = pd.DataFrame(index=['A', 'B'])
table8['prior'] = 1/2
table8['likelihood'] = 0.2*0.2, 0.14*0.1
update(table8)

#print(table8)