<?php
// jkhleairways_connect_theme
// based on sky by Adaptivethemes.com

/**
 * Override or insert variables into the html template.
 */
function thinkibm_connect_theme_preprocess_html(&$vars) {
  global $theme_key;
  $theme_name = $theme_key;

  // Add class for the active theme
  $vars['classes_array'][] = drupal_html_class($theme_name);
}
