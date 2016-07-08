
% inputs: amplitudeSpectrum,f,fmin,fmax

function [rms] = bandRMS(fft,f,fmin,fmax)
df=f(2)-f(1);
1/df;
    imin = find(f >= fmin-df/2 & f<fmin+df/2);
    imax = find(f <= fmax+df/2 & f>fmax-df/2);
sum = 0;
for i=imin:imax
   %fft(i)
        sum = sum + fft(i)*fft(i)*df;
end
rms = sqrt(sum);
