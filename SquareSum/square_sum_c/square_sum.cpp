#include <iostream>
#include <iterator>
#include <set>
#include <cstdlib>
#include <chrono>
#include <cmath>

using namespace std;
using namespace std::chrono;

bool is_square(int n) {
    int k = (int) sqrt(n);
    return k*k == n;
}

// Rearrange 1..size such that any two adjacent numbers add to a square number
void solve(int size) {
    // Already arranged numbers
    int partial_list[size];
    // Last tried number to be appended after each position, for backtracking
    int last_tried[size];
    // Current tail of already arranged numbers
    int current;

    // Bitset for remembering already used numbers
    bool used[size + 1]; 

    for (int i = 1; i <= size; i ++) {
        for (int k = 1; k <= size; k ++)
            used[k] = false;

        current = 0;
        partial_list[current] = i;
        used[i] = true;
        last_tried[current] = 0;

        while (current >= 0) {
            if (current == size - 1) {
                for (int i = 0; i < size; i ++)
                    cout << partial_list[i] << " ";
                cout << endl;
                return;
            }

            // Find next potential number to append to the end of the list, starting 
            // from one above the last number tried
            int next;
            for (next = last_tried[current] + 1; next <= size; next ++) {
                // bool used = false;
                // for (int i = 0; i <= current; i ++) {
                //     if (partial_list[i] == next) {
                //         used = true;
                //         break;
                //     }
                // }
                // if (used)
                //     continue;
                if (used[next])
                    continue;

                if (!is_square(next + partial_list[current]))
                    continue;

                last_tried[current] = next;
                current ++;
                partial_list[current] = next;
                last_tried[current] = 0;
                used[next] = true;
                break;

                next ++;
            }
            if (next > size) {
                used[partial_list[current]] = false;
                current --;
            }
        }
    }
}

int main(int argc, char* argv[]) {
    int size = atoi(argv[1]);
    time_point start = steady_clock::now(); 
    solve(size);
    time_point stop = steady_clock::now();
    seconds duration = duration_cast<seconds>(stop - start); 
    cout << "Time: " << duration.count() << " seconds" << endl; 
    return 0;
}
