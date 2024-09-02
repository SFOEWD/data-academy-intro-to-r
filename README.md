
This repository contains the course materials for Data Academy’s
Introduction to R course.

## Lab

1.  Read `data/flights.rds` into R, naming the output `flights`.

2.  From `flights`, select the year, month, and day columns.

3.  From `flights`, select all columns except carrier.

4.  Sort `flights` to find the flights with longest departure delays.

5.  Sort `flight` by departure delay in descending order.

6.  Rename the tailnum column to tail_num.

7.  Find the distinct origins.

8.  Find the distinct combinations of origins and destinations.

9.  Filter `flight` for the first day of January or February.

10. Find all flights that meet these conditions:

- Had an arrival delay of two or more hours
- Flew to Houston (IAH or HOU)
- Were operated by United, American, or Delta
- Departed in summer (July, August, and September)

11. Count the flight destinations by origin.

12. Create a new column ‘speed’ that is distance divided by air time
    multiplied by 60.

13. Create a new column ‘flight_hours’ that is the air_time divided by
    60.

14. In a pipeline (consecutive pipes), filter `flights` where neither
    `arr_delay` and `tailnum` are not NA. Then count the destinations.

15. In a pipeline (consecutive pipes), filter `flights` where the
    destination is “IAH”, then find the average arrival delays, grouped
    by year, month, and day.

16. Which carrier has the highest average delays?

17. During which month is there the highest average departure delays?

18. Read `data/airports.rds` into R, naming the output `airports`.

19. Filter `airports` where ‘Intl’ is in the name, then rename the `faa`
    column to `dest`. Save the output to a data frame called
    `intl_airports`.

20. In a single pipeline, select `sched_arr_time`, `arr_delay`, `dest`
    from `flights`, left join `intl_airports` using `dest` as the ‘key’,
    and then count the airport names. Sort the output.

21. A pattern we haven’t seen yet is `group_by()` followed by
    `mutate()`. Compare the two outputs below:

``` r
penguins %>% 
  group_by(island) %>% 
  summarize(mean_flipper_length = mean(flipper_length_mm, na.rm = TRUE))

penguins %>% 
  group_by(island) %>% 
  mutate(mean_flipper_length = mean(flipper_length_mm, na.rm = TRUE))
```

How are they different? How does the output change if we add
`%>% ungroup()` to the end? Why might we want to add `ungroup()` after
we’ve completed a grouping operation?
