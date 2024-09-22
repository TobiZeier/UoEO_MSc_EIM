import pandas as pd

gss = pd.read_csv('gss_bayes.csv')

banker = (gss['indus10'] == 6870)
male = (gss['sex'] == 1)
female = (gss['sex'] == 2)
liberal = (gss['polviews'] <= 3)
democrat = (gss['partyid'] <= 1)
young = (gss['age'] < 30)
old = (gss['age'] >= 65)
conservative = (gss['polviews'] >= 5)


def prob(A):
    """Computes the probability of a proposition, A."""
    return A.mean()


def conditional(proposition, given):
    """Probability of A conditioned on given."""
    return prob(proposition[given])

#1.6 Conjunction
#print(prob(banker & female & liberal & democrat))

#1.7 Conditional Probability
#print(selected = female[banker])
#print(conditional(liberal, given=female))

#1.8 Conditional Probability Is Not Commutative
#print(conditional(female, given=banker))
#print(conditional(banker, given=female))

#1.9. Condition and Conjunction
#print(conditional(female, given=liberal & democrat))
#print(conditional(liberal & female, given=banker))

#1.10. Laws of Probability

#1.10.1. Theorem 1
#print(female[banker].mean())
#print(conditional(female, given=banker))
#print(prob(female & banker) / prob(banker))

#1.10.2. Theorem 2
#print(prob(liberal & democrat))
#print(prob(democrat) * conditional(liberal, democrat))

#1.10.3. Theorem 3
#print(conditional(liberal, given=banker))
#print(prob(liberal) * conditional(banker, liberal) / prob(banker))

#1.11. The Law of Total Probability
#print(prob(banker))
#print(prob(male & banker) + prob(female & banker))

#1.13. Exercises
#print(conditional(liberal, given=democrat))
#print(conditional(democrat, given=liberal))

#print(conditional(banker, given=female))
#print(conditional(banker & liberal & democrat, given=female))

#print(prob(young & liberal))
#print(conditional(liberal, given=young))
#print(prob(old & conservative))
#print(conditional(old, given=conservative))