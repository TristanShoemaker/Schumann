function value = homestake_calculate_percentiles(data,range,percentile)

cumsum_values = cumsum(data);

which_percentile= find(min(abs(cumsum_values-percentile)) == abs(cumsum_values-percentile));
if ~isempty(which_percentile)
   value = range(which_percentile(end));
else
   value = 0;
end

