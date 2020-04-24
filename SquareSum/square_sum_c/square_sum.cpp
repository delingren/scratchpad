#include <iostream>
#include <iterator>
#include <set>
#include <cstdlib>

using namespace std;

void solve(int size) {
    set<int> squares;
    for (int i = 2; i*i < 2*size; i ++)
        squares.insert(i*i);

    int partial_list[size];
    int last_tried[size];
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

            // Find next possible number to append to the end of the list, starting 
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

                if (squares.end() == squares.find(next + partial_list[current]))
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
    solve(size);
    return 0;
}