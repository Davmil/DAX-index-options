%% Calls
clear;
close all;

load mydatc;

DateLoop = unique(mydatc.Date);
nFrames = length(DateLoop);
% nFrames = 40;

disp(nFrames)

% Preallocate movie structure.
M(1:nFrames) = struct('cdata', [],...
                        'colormap', []);


% volsrf = mydatc(strcmp(mydatc.Date,'2008-01-17'),[5 9 12 7]); % Maturity, ImplVola
figure('position',[100 100 1200 800])


for i = 1:nFrames
    Zeit = DateLoop(i);
    volsrf = mydatc(strcmp(mydatc.Date,DateLoop(i)),[5 9 12 7]); % Maturity, ImplVola
    frametmp = VolSurf2(volsrf.Time_to_Maturity, volsrf.Strike, volsrf.ImplVola, Zeit);
    % disp(srf) 
    % savefig('figures/Vola_surface2_01_17_2008.fig');
    % Store the frame
    M(i)=frametmp;
end

close all;

save mymov M;

% movie(M)
% movie2avi(M,'FinMovie.avi', 'compression', 'None');

%% Puts
clear;
close all;
load mydatp;

DateLoop = unique(mydatp.Date);
nFrames = length(DateLoop);
% nFrames = 40;

disp(nFrames)

% Preallocate movie structure.
M(1:nFrames) = struct('cdata', [],...
                        'colormap', []);


% volsrf = mydatc(strcmp(mydatc.Date,'2008-01-17'),[5 9 12 7]); % Maturity, ImplVola
figure('position',[100 100 1200 800])


for i = 1:nFrames
    Zeit = DateLoop(i);
    volsrf = mydatp(strcmp(mydatp.Date,DateLoop(i)),[5 9 12 7]); % Maturity, ImplVola
    frametmp = VolSurf2(volsrf.Time_to_Maturity, volsrf.Strike, volsrf.ImplVola, Zeit);
    % disp(srf) 
    % savefig('figures/Vola_surface2_01_17_2008.fig');
    % Store the frame
    M(i)=frametmp;
end

close all;

save mymovP M;

% movie(M)
% movie2avi(M,'FinMovieP.avi', 'compression', 'None');
