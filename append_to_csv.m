%Appends the passed arrays to the CSV file
%Returns 1 if successful, 0 if an error occured

function n = append_to_csv(name, time, positions ,velocities)
        M = [time positions velocities];
            dlmwrite(name, M,'precision','%.6f', '-append');           
    n=1;
end