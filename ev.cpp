#include "omp/EquityCalculator.h"
#include "iostream"
using namespace omp;
using namespace std;
int main()
{
    EquityCalculator eq;
    vector<CardRange> ranges{"55+,A2s+,K4s+,Q6s+,J7s+,T7s+,98s,A5o+,K8o+,Q9o+,J9o+,T9o", "JJ-22,AJs-A9s,KJs-K9s,Q9s+,J9s+,T9s,A3o-A2o,K3o-K2o,Q3o-Q2o,J3o-J2o,T2o,92o,83o-82o,72o,63o-62o,53o-52o,42o,32o", "AA", "JJ-22,AJs-A9s,KJs-K9s,Q9s+,J9s+,T9s,A3o-A2o,K3o-K2o,Q3o-Q2o,J3o-J2o,T2o,92o,83o-82o,72o,63o-62o,53o-52o,42o,32o", "22+", "22+,ATs+,KTs+,QTs+,JTs,75s,64s,54s,ATo+,KTo+,QTo+,JTo,64o"};
    //uint64_t board = CardRange::getCardMask("2c4c5h");
    //uint64_t dead = CardRange::getCardMask("Jc");
    double stdErrMargin = 2e-4; // stop when standard error below 0.002%
    auto callback = [&eq](const EquityCalculator::Results& results) {
        cout << results.equity[0] << " " << 100 * results.progress
                << " " << 1e-6 * results.intervalSpeed << endl;
        if (results.time > 5) // Stop after 5s
            eq.stop();
    };
    double updateInterval = 0.25; // Callback called every 0.25s.
    unsigned threads = 5; // max hardware parallelism (default)
    eq.start(ranges, false, false, false, stdErrMargin, callback, updateInterval, threads);
    eq.wait();
    auto r = eq.getResults();
    cout << endl << r.equity[0] << " " << r.equity[1] << " " << r.equity[2] << " " << r.equity[3] << " " << r.equity[4] << " " << r.equity[5] << endl;
    cout << r.wins[0] << " " << r.wins[1] << " " << r.wins[2] << endl;
    cout << r.hands << " " << r.time << " " << 1e-6 * r.speed << " " << r.stdev << endl;
}
