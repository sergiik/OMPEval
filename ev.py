import pyCardRange

pyCardRange.PyCardRange("55+,A2s+,K4s+,Q6s+,J7s+,T7s+,98s,A5o+,K8o+,Q9o+,J9o+,T9o")
p = pyCardRange.PyEquityCalculator()
p.start(["55+, A2s+", "AA"])
p.wait()
print p.getResults().getEquity()
