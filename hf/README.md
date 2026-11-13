---
license: cc-by-4.0
language:
  - en
pretty_name: London extension costs and planning approvals
size_categories:
  - n<1K
task_categories:
  - tabular-regression
tags:
  - london
  - construction
  - housing
  - planning
  - home-improvement
configs:
  - config_name: cost_index
    data_files: data/london-extension-cost-index.csv
    default: true
  - config_name: planning_approvals
    data_files: data/london-planning-approvals.csv
---

# London extension costs and planning approvals

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.24195670.svg)](https://doi.org/10.5281/zenodo.24195670)

Open data from [Cost My Extension](https://costmyextension.co.uk) on what house extensions and loft conversions cost in each London borough, and how each council decides householder planning applications. The data is refreshed weekly from the live site.

| File | What it is | Updated |
|---|---|---|
| [`data/london-extension-cost-index.csv`](https://github.com/costmyextension/london-extension-data/tree/main/data/london-extension-cost-index.csv) | Typical all-in cost of a rear extension, a side-return extension and a loft conversion in all 32 London boroughs | When the rates are rechecked |
| [`data/london-planning-approvals.csv`](https://github.com/costmyextension/london-extension-data/tree/main/data/london-planning-approvals.csv) | Householder extension and loft decisions per borough over the last 90 days: decided, approved, approval rate, typical wait | Weekly |
| [`data/history/`](https://github.com/costmyextension/london-extension-data/tree/main/data/history) | One dated copy of each edition, so changes can be compared over time | With each edition |

The same tables, with charts and explanations, are on the site:
- [London extension cost index](https://costmyextension.co.uk/london-extension-cost-index)
- [London planning approvals by borough](https://costmyextension.co.uk/london-planning-approvals)

## The cost index

One row per borough and job family.

| Column | Meaning |
|---|---|
| `borough` | London borough |
| `job_family` | House extension, Side-return extension or Loft conversion |
| `typical_job` | The job priced for that family, for example "Single-storey rear extension" or "Loft conversion with a rear dormer" |
| `low_gbp`, `expected_gbp`, `high_gbp` | Likely all-in total in pounds, including VAT: building work plus professional and council fees, before contingency |
| `build_per_m2_low_gbp`, `build_per_m2_high_gbp` | Build cost per square metre of new floor area, including VAT |
| `rates_date` | The day the rates behind the figures were last checked |

The figures are for a typical house of the borough's most common type, a good-quality finish and no extras such as a new kitchen. They come from a deterministic cost engine with dated, versioned rates and a borough adjustment. How it works is explained at [costmyextension.co.uk/how-it-works](https://costmyextension.co.uk/how-it-works), and how the figures are checked and kept current at [costmyextension.co.uk/about](https://costmyextension.co.uk/about).

**These are estimates for a typical house, not a quote, a survey or planning advice.** A real price depends on the house, the design, access and the builder.

## The planning approvals table

One row per borough, then London as a whole.

| Column | Meaning |
|---|---|
| `area` | London borough, or `London` for all rated boroughs together |
| `decided` | Decisions made in the window, approved or refused (withdrawn applications are not counted) |
| `approved` | Of those, approved, including "prior approval not required" and certificates granted |
| `approval_rate_pct` | `approved / decided`, as a whole percentage. Empty where `rated` is `no` |
| `against_london` | Whether the borough sits above, in line with or below the London rate |
| `median_weeks` | Typical wait from a valid application to a decision, in weeks |
| `rated` | `no` where too few decisions matched for a fair rate |
| `window_from`, `window_to` | The 90 days covered |

Included: householder applications, larger home extension prior approvals and proposed-use lawful development certificates for extensions and loft conversions. Each decision is sorted into a job from its description. Street names, house numbers and applicants are left out. Coverage depends on what each council sends to the datahub, and some councils send few or no records (`rated` = `no`).

**Source:** [Planning London Datahub](https://planningdata.london.gov.uk/), Greater London Authority. The datahub publishes its data openly through a public guest API and names no licence. The figures here are Cost My Extension's counts and rates derived from those records.

## Licence and how to cite

Both tables are published under [Creative Commons Attribution 4.0 (CC BY 4.0)](https://creativecommons.org/licenses/by/4.0/). You may reuse them, including commercially, with credit to **Cost My Extension** and a link to **https://costmyextension.co.uk**.

Suggested citation:

> Cost My Extension (2026). *London extension costs and planning approvals* [Data set]. Zenodo. https://doi.org/10.5281/zenodo.24195670

The DOI above, 10.5281/zenodo.24195670, always points to the latest release. Each monthly release on Zenodo also has its own DOI, for citing one edition exactly. The [`CITATION.cff`](https://github.com/costmyextension/london-extension-data/blob/main/CITATION.cff) file gives the same details in a machine-readable form.

The data is mirrored on Hugging Face at [costmyextension/london-extension-data](https://huggingface.co/datasets/costmyextension/london-extension-data).

## How it is updated

A GitHub Action ([`.github/workflows/sync.yml`](https://github.com/costmyextension/london-extension-data/blob/main/.github/workflows/sync.yml)) runs every Monday:
1. It downloads both tables from the site.
2. It commits any change.
3. On the first run of each month, it creates a release named after the month, which Zenodo archives.
4. It mirrors `data/` to Hugging Face.

To refresh the files by hand, run `scripts/sync.sh`.

Corrections and questions: oliver@costmyextension.co.uk
