function movefiles(cell_arr_of_filenames,destination,chunkSize)
% Move CHUNKSIZE files at a time. (system() commands can only be a certain character length)
if nargin<3, chunkSize = 100; end
n = length(cell_arr_of_filenames);
chunks = unique([(1:chunkSize:n) n]);
for i = 1:length(chunks)-1
    inds = chunks(i):chunks(i+1);
    fileListStr = sprintf(' "%s"', cell_arr_of_filenames{inds});
    cmd_str = sprintf('for %%f in (%s) do move %%f "%s"', fileListStr, destination);
    fprintf('Moving %d to %d of %d files to "%s" ...', inds([1 end]), n, destination);
    [status, result] = system(cmd_str);
    if status==0
        fprintf(' done!\n')
    else
        error(result)
    end
end