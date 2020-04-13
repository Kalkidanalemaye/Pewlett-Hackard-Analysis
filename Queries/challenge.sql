SELECT ri.emp_no,
	ce.first_name,
	ce.last_name,
	t.title,
	t.from_date,
	s.salary
INTO mentor_info
FROM current_emp as ce
INNER JOIN retirement_info AS ri
ON (ce.emp_no = ri.emp_no)
INNER JOIN titles AS t
ON (ri.emp_no = t.emp_no)
INNER JOIN salaries AS s
ON (t.emp_no = s.emp_no);


SELECT * FROM mentor_info
ORDER BY from_date DESC;

SELECT * FROM
  (SELECT *, count(*)
  OVER
    (PARTITION BY
      first_name,
      last_name
    ) AS count
  FROM mentor_info) tableWithCount
  WHERE tableWithCount.count > 1;
 
SELECT DISTINCT ON (first_name, last_name) * FROM mentor_info;


DELETE FROM mentor_info WHERE mentor_info.emp_no NOT IN 
(SELECT emp_no FROM (
    SELECT DISTINCT ON (first_name, last_name) *
  FROM mentor_info) AS emp_no);
 
SELECT COUNT(m.emp_no), m.title
INTO per_title
FROM mentor_info AS m
GROUP BY m.title
ORDER BY m.title;

SELECT e.emp_no,
	e.first_name,
	e.last_name,
	t.title,
	t.from_date,
	t.to_date
INTO ready_mentor
FROM employees as e
INNER JOIN titles as t
ON (e.emp_no = t.emp_no)
WHERE (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
	AND t.to_date = ('9999-01-01');
  