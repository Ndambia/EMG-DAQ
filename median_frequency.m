function median_frequency = medfreq(y, fs)
    % Compute the length of the signal
    n = length(y);

    % Compute the Fourier transform of the signal
    Y = fft(y);

    % Compute the single-sided spectrum P1
    P2 = abs(Y/n);
    P1 = P2(1:floor(n/2)+1);
    P1(2:end-1) = 2*P1(2:end-1);

    % Define the frequency domain
    f = fs*(0:floor(n/2))/n;

    % Compute the cumulative sum of the spectrum
    csum = cumsum(P1);

    % Find the index of the frequency at which the cumulative sum is half the total sum
    [~, index] = min(abs(csum - sum(P1)/2));

    % Calculate the median frequency
    median_frequency = f(index);
end

