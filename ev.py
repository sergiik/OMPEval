import pyCardRange


def callback(r):
	print(r)

#r2 = pyCardRange.PyCardRange("AA")
p = pyCardRange.PyEquityCalculator()
#r1 = pyCardRange.PyCardRange("55+, A2s+")
p.start(["55+, A2s+", "AA"], callback)
p.wait()
print(p.getResults().getEquity())
