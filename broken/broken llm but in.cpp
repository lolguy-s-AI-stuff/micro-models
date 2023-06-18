#include <cstdio>
#include <vector>
#include <cstdlib>
#include <algorithm>
#include <ctime>
#include <string>
double fRand(double fMin, double fMax) {
    double f = (double)rand() / RAND_MAX;
    return fMin + f * (fMax - fMin);
}

class SmallLLMModel {
private:
    std::vector<int> weights;
    int charCap;

public:
    SmallLLMModel() : charCap(256) {
        weights.resize(1024);
        init();
    }

    void init() {
        std::fill(weights.begin(), weights.end(), 0);
    }

    char predict(const std::string& current) {
        if (current.length() >= charCap) {
            return ' ';
        }
        std::vector<int> toRet(256, 0);
        std::vector<int> toRet1(256, 0);
        int ret3 = 0;
        for (size_t i = 0; i < current.length(); i++) {
            toRet[i] += current[i] * weights[i];
        }
        for (size_t i = 0; i < toRet.size(); i++) {
            toRet1[i] += toRet[i] * weights[i];
        }
        for (size_t i = 0; i < toRet1.size(); i++) {
            ret3 += toRet1[i] * weights[256 + i];
        }
        int asciiCode = 33 + (ret3 % 93);
        if (asciiCode < 33) {
            asciiCode += 93;
        }
        return static_cast<char>(asciiCode);
    }

    int test(const std::string& input) {
        srand(static_cast<unsigned int>(time(0)));
        size_t n = rand() % (input.length() - 2);

        char predChar = predict(input.substr(0, n));
        char correctChar = input[n + 1];

        if (predChar != '\0' && correctChar != '\0') {
            int score = abs(predChar - correctChar);
            if (predChar == input[n]) {
                score -= 400;
            }
            return score * score;
        } else {
            return 0;
        }
    }

    void demo(const std::string& input) {
        std::string res = input;
        std::string current = input;
        for (int j = 0; j <= 100; j++) {
            char predChar = predict(current);
            res += predChar;
            current += predChar;
        }
        printf("%s\n", res.c_str());
    }

    void train() {
        std::vector<std::string> trainData = {
            "The quick brown fox jumps over the lazy dog.",
            "Hello, World!",
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
            "Artificial Intelligence is the future of technology.",
            "Machine Learning is revolutionizing various industries.",
            "Deep learning models require large amounts of data for training."
        };

        int epoch = 0;
        while (true) {
            int preScore = test(trainData[std::rand() % trainData.size()]);
            for (size_t i = 0; i < weights.size(); i++) {
                int postScore = test(trainData[std::rand() % trainData.size()]);
                int diff = preScore - postScore;
                if (diff != 0) {
                    int gradient = (diff > 0) ? 1 : -1;
                    // learning rate I think
                    weights[i] += diff * 0.001 * gradient;
                }
                preScore = test(trainData[std::rand() % trainData.size()]);
            }
            epoch++;
            printf("Epoch #%d\r", epoch);

            if (epoch % 10000 == 0) {
                printf("===== Sample =====\n");
                demo("Hello world");
                printf("==================\n\n");
            }
        }
    }
};

int main() {
    SmallLLMModel model;
    model.train();

    return 0;
}