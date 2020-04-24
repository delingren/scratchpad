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

    for (int i = 1; i <= size; i ++) {
        current = 0;
        partial_list[current] = i;
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
                bool used = false;
                for (int i = 0; i <= current; i ++) {
                    if (partial_list[i] == next) {
                        used = true;
                        break;
                    }
                }
                if (used)
                    continue;

                if (!is_square(next + partial_list[current]))
                    continue;

                last_tried[current] = next;
                current ++;
                partial_list[current] = next;
                last_tried[current] = 0;
                break;

                next ++;
            }
            if (next > size)
                current --;
        }
    }
}

int main(int argc, char* argv[]) {
    int size = atoi(argv[1]);
    time_point start = high_resolution_clock::now(); 
    solve(size);
    time_point stop = high_resolution_clock::now();
    microseconds duration = duration_cast<microseconds>(stop - start); 
    cout << "Time: " << duration.count() << " microseconds" << endl; 
    return 0;
}