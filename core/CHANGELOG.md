## 1.0.0

> Note: This release has breaking changes.

- **FEAT**: Add `ChainedExperimentAdapter`.
- **BREAKING** **FEAT**: Ensure different user segments for each experiment in `LocalAdapter`.

## 0.16.0+2

- **FEAT**: Use default variant on invalid values for enumerated experiments.

## 0.16.0+1

 - **DOCS**: fix headings in CHANGELOGs.

## 0.16.0

> Note: This release has breaking changes.

- **FEAT**: Provide support for custom experiments
- **BREAKING** **FEAT**: Rename allExperiments getter to experiments.

## 0.15.0

> Note: This release has breaking changes.

 - **FEAT**: inactive experiments getter ([#4](https://github.com/programmierbar/ab_testing/issues/4)).
 - **DOCS**: fix headings in CHANGELOGs.
 - **BREAKING** **FEAT**: Move update method to base ExperimentAdapter.
 - **BREAKING** **FEAT**: Change enabled and active flag handling.

## 0.14.0

> Note: This release has breaking changes.

 - **BREAKING** **FEAT**: Move update method to base ExperimentAdapter. ([7f227215](https://github.com/programmierbar/ab_testing/commit/7f2272155db1a70b2f734f4c049105f9c576d6a7))
 - **BREAKING** **FEAT**: Change enabled and active flag handling. ([2169e744](https://github.com/programmierbar/ab_testing/commit/2169e744cfca2fe6618c4f2b87900e72a56fd0f6))

## 0.13.0

> Note: This release has breaking changes.

 - **FEAT**: Add CachingAdapter to improve production setups. ([1a59f1cb](https://github.com/programmierbar/ab_testing/commit/1a59f1cbadec513f5c0c12aba452a86034c40dda))
 - **BREAKING** **FIX**: resolve inactive value on load in FirebaseAdapter. ([dd26ff39](https://github.com/programmierbar/ab_testing/commit/dd26ff39f7e25e6edea083fea9abfe85f32ccfc8))

## 0.12.0+1

 - **FIX**: active flag check and parsing of invalid enum variants. ([16f7ed80](https://github.com/programmierbar/ab_testing/commit/16f7ed80cdf33e56034cfaa9aa4daf0c6b7db5e9))
 - **FIX**: Fix check for existing value in active property. ([295a6f87](https://github.com/programmierbar/ab_testing/commit/295a6f874951f509250102ad8cb1e8454f3d5684))

## 0.12.0

> Note: This release has breaking changes.

 - **BREAKING** **FIX**: do not require variants for text and numeric experiments. ([c57a7536](https://github.com/programmierbar/ab_testing/commit/c57a75367ea30655c899b9278a7612890a5bf9cd))

## 0.11.0

> Note: This release has breaking changes.

 - **BREAKING** **FEAT**: Pass complete experiment config to logger. ([e1f36960](https://github.com/programmierbar/ab_testing/commit/e1f369604cfedaef409db2c5fa0b5d7ece917301))

## 0.10.0

> Note: This release has breaking changes.

 - **BREAKING** **FEAT**: a number of improvements. ([57f6453e](https://github.com/programmierbar/ab_testing/commit/57f6453e4dd99727bbe9f9a666648196878f431d))

## 0.9.1
* Update dependencies

## 0.8.2
* Add image

## 0.8.1
* Adjust changelog

## 0.8.0
* Initial release