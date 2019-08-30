#!/usr/bin/env nextflow
/*
========================================================================================
                         lifebit-ai/dean
========================================================================================
 lifebit-ai/dean Differential Expression Analysis Nextflow pipeline using DEseq2
 #### Homepage / Documentation
 https://github.com/lifebit-ai/dean
----------------------------------------------------------------------------------------
*/

Channel
  .fromPath(params.feature_counts)
  .ifEmpty { exit 1, "Feature counts file not found: ${params.feature_counts}" }
  .set { feature_counts }
Channel
  .fromPath(params.annotation)
  .ifEmpty { exit 1, "Sample groups annotation file not found: ${params.annotation}" }
  .set { annotation  }
Channel
  .fromPath(params.rmarkdown)
  .ifEmpty { exit 1, "Sample groups annotation file not found: ${params.rmarkdown}" }
  .set { rmarkdown  }

/*--------------------------------------------------
  Run differential expression analysis with DEseq2 
---------------------------------------------------*/

process deseq2 {
  tag "$feature_counts"
  publishDir params.outdir, mode: 'copy'

  input:
  file(feature_counts) from feature_counts
  file(annotation) from annotation
  file(rmarkdown) from rmarkdown

  output:
  file('MultiQC/multiqc_report.html') into results

  script:
  """
  # copy the rmarkdown into the pwd
  cp $rmarkdown tmp && mv tmp $rmarkdown

  R -e "rmarkdown::render('${rmarkdown}', params = list(feature_counts='${feature_counts}',annotation='${annotation}',condition='${params.condition}'))"

  mkdir MultiQC && mv DE_with_DEseq2.html MultiQC/multiqc_report.html
  """
}
