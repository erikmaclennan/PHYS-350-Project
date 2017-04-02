%Appends the passed arrays to the CSV file
%Returns 1 if successful, 0 if an error occured

function append_to_csv(name, time, positions ,velocities)
            positions1 = positions';
            velocities1 = velocities';
            positions2 = reshape(positions1,[],1);
            velocities2 = reshape(velocities1, [], 1);

            M = [time positions velocities];
            dlmwrite(name, M,'precision','%.6f', '-append');           
end

