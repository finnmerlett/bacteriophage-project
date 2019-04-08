function struct_subset = struct_filter(struct_in,field,filter_value)
%STRUCT_FILTER struct_subset = struct_filter(struct_in,field,filter_value)
%   Returns a subset of the struct parameter, filtered by specified field
%   accordingly
struct_subset = struct_in(strcmp({struct_in.(field)}, filter_value));
end

